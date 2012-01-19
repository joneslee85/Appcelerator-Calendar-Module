/*
 * Copyright (c) 2008, Keith Lazuka, dba The Polypeptides
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *	- Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *	- Neither the name of the The Polypeptides nor the
 *	  names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY Keith Lazuka ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Keith Lazuka BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

//
//    NOTES
//
//        (1) Everything is drawn relative to self's bounds so that
//            the graphics can be scaled nicely just by changing the bounds
//
//        (2) Since Core Animation can linearly interpolate the view's bounds
//            you can easily zoom the view into this tile and everything will
//            look nice as soon as you redraw it.
//
//        (3) When a tile is marked as "commented", the tile will display
//            a small circle indicator near the bottom middle of the tile.
//
//        (4) When a tile is marked as "checkmarked", a large green checkmark
//            will be drawn over the tile.
//
//        (5) If you change either the commented or the checkmarked properties
//            on this tile, you must call 'setNeedsDisplay' on the tile
//            in order for the changes to become visible.
//

#import "KLTile.h"
#import "KLDate.h"
#import "KLColors.h"
#import <QuartzCore/QuartzCore.h>

static CGGradientRef TextFillGradient;

__attribute__((constructor))        // Makes this function run when the app loads
static void InitKLTile()
{
    // prepare the gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGColorRef rawColors[2];
   // rawColors[0] = CreateRGB(0.173f, 0.212f, 0.255f, 1.0f);
  //  rawColors[1] = CreateRGB(0.294f, 0.361f, 0.435f, 1.0f);
   // rawColors[0] = CreateRGB(0.6f, 0.06f, 0.67f, 1.0f);
  //  rawColors[1] = CreateRGB(0.6f, 0.06f, 0.67f, 1.0f);
    
    rawColors[0] = CreateRGB(0.0f, 0.0f, 0.0f, 1.0f);
    rawColors[1] = CreateRGB(0.0f, 0.0f, 0.0f, 1.0f);

    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);

    // create it
    TextFillGradient = CGGradientCreateWithColors(colorSpace, colors, NULL);

    CGColorRelease(rawColors[0]);
    CGColorRelease(rawColors[1]);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);

}

@interface KLTile ()
- (CGFloat)thinRectangleWidth;
@end

@implementation KLTile

@synthesize text = _text, date = _date;
//@synthesize todayTextColor = _todayTextColor, todayBGColor = _todayBGColor;
@synthesize checkmarked;

- (id)init
{
    if (![super initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)])
        return nil;

    self.backgroundColor = [UIColor colorWithCGColor:kTileNormalBGColor];
    [self setTextTopColor:kTileTodayTextColor];
    [self setTextBottomColor:kTileTodayTextColor];
    _todayBGColor = kTileTodayBGColor;
    _todayTextColor = kTileTodayTextColor;

    self.clipsToBounds = YES;

    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { [[self superview] touchesBegan:touches withEvent:event]; }
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { [[self superview] touchesMoved:touches withEvent:event]; }

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1)
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else
        [[self superview] touchesEnded:touches withEvent:event];
}

- (void)drawInnerShadowRect:(CGRect)rect percentage:(CGFloat)percentToCover context:(CGContextRef)ctx
{
    CGFloat width = floorf(rect.size.width);
    CGFloat height = floorf(rect.size.height) + 4;
    CGFloat gradientLength = percentToCover * height;

    CGColorRef startColor = CreateRGB(0.0f, 0.0f, 0.0f, 0.4f);  // black 40% opaque
    CGColorRef endColor = CreateRGB(0.0f, 0.0f, 0.0f, 0.0f);    // black  0% opaque
    CGColorRef rawColors[2] = { startColor, endColor };
    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);

    CGContextClipToRect(ctx, rect);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(0, gradientLength), kCGGradientDrawsAfterEndLocation); // top
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(width,0), CGPointMake(width-gradientLength, 0) , kCGGradientDrawsAfterEndLocation); // right
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,height), CGPointMake(0, height-gradientLength), kCGGradientDrawsAfterEndLocation); // bottom
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(gradientLength, 0) , kCGGradientDrawsAfterEndLocation); // left

    CGGradientRelease(gradient);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(startColor);
    CGColorRelease(endColor);
}

- (CGFloat)thinRectangleWidth { return 1+floorf(0.02f * self.bounds.size.width); }        // 1pt width for 46pt tile width (2pt for 4x scale factor)

- (void)drawGradient:(CGRect)rect percentage:(CGFloat)percentToCover context:(CGContextRef)ctx
{
    CGFloat height = floorf(rect.size.height) + 4;
    CGFloat gradientLength = percentToCover * height;
    
    CGColorRef startColor = CreateRGB(0.51f, 0.22f, 0.61, 0.7f);  // black 40% opaque
    CGColorRef endColor = CreateRGB(1.0f, 1.0f, 1.0f, 0.3f);    // black  0% opaque
    CGColorRef rawColors[2] = { startColor, endColor };
    CFArrayRef colors = CFArrayCreate(NULL, (void*)&rawColors, 2, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
    
    CGContextClipToRect(ctx, rect);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0,0), CGPointMake(0, gradientLength), kCGGradientDrawsAfterEndLocation); 
    
    CGGradientRelease(gradient);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(startColor);
    CGColorRelease(endColor);
    
}

- (void)drawTextInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGFloat numberFontSize = floorf(0.4f * width);

    // create a clipping mask from the text for the gradient
    // NOTE: this is a pain in the ass because clipping a string with more than one letter
    //       results in the clip of each letter being superimposed over each other,
    //       so instead I have to manually clip each letter and draw the gradient
    CGContextSetFillColorWithColor(ctx, kDarkCharcoalColor);
    CGContextSetTextDrawingMode(ctx, kCGTextClip);

    CGFloat left = 0;

    for (NSInteger i = 0; i < [self.text length]; i++) {
        NSString *letter = [self.text substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithFont:[UIFont boldSystemFontOfSize:numberFontSize]];

        CGContextSaveGState(ctx);  // I will need to undo this clip after the letter's gradient has been drawn

        if (left == 0) {
            if ([self.text length] == 1) {
                left = (self.bounds.size.width - letterSize.width)/2;
            } else {
                left = (self.bounds.size.width - (letterSize.width * 2))/2;
            }
        }

        [letter drawAtPoint:CGPointMake(left+(letterSize.width*i), 11.0f) withFont:[UIFont boldSystemFontOfSize:numberFontSize]];
        
        if ([self.date isToday]) {
            CGContextSetFillColorWithColor(ctx, _todayTextColor);
            CGContextFillRect(ctx, self.bounds);  
        } else if(self.checkmarked){
            CGContextSetFillColorWithColor(ctx, kTilePinkColor);
            CGContextFillRect(ctx, self.bounds);
        } else {
            // nice gradient fill for all tiles except today
            CGContextDrawLinearGradient(ctx, TextFillGradient, CGPointMake(0,0), CGPointMake(0, height/3), kCGGradientDrawsAfterEndLocation);
        }

        CGContextRestoreGState(ctx);  // get rid of the clip for the current letter        
    }

    CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat lineThickness = [self thinRectangleWidth];  // for grid shadow and highlight


    // dark grid line
    CGContextSetFillColorWithColor(ctx, kGridDarkColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, width, lineThickness));                    // top
    CGContextFillRect(ctx, CGRectMake(width-lineThickness, 0, lineThickness, height)); // right

    // highlight
    CGContextSetFillColorWithColor(ctx, kGridLightColor);
    CGContextFillRect(ctx, CGRectMake(0, lineThickness, width-lineThickness, lineThickness));                    // top
    CGContextFillRect(ctx, CGRectMake(width-2*lineThickness, lineThickness, lineThickness, height-lineThickness)); // right
    
     if([self.date isToday] && self.checkmarked) {
         CGContextSaveGState(ctx);
         CGRect innerBounds = self.bounds;
         innerBounds.size.width -= lineThickness;
         innerBounds.size.height -= lineThickness;
         innerBounds.origin.y += lineThickness;
         CGContextSetFillColorWithColor(ctx, kTilePurpleColor);
         CGContextFillRect(ctx, innerBounds);
         CGContextRestoreGState(ctx);
     } else {
            if(self.checkmarked){
                [self drawGradient:rect percentage:1.0f context:ctx];
            }
            
            // Highlight if this tile represents today
            if ([self.date isToday]) {
                CGContextSaveGState(ctx);
                CGRect innerBounds = self.bounds;
                innerBounds.size.width -= lineThickness;
                innerBounds.size.height -= lineThickness;
                innerBounds.origin.y += lineThickness;
                CGContextSetFillColorWithColor(ctx, _todayBGColor);
                CGContextFillRect(ctx, innerBounds);
                CGContextRestoreGState(ctx);

            }
     }

    // Draw the # for this tile
    [self drawTextInContext:ctx];
}
// --------------------------------------------------------------------------------------------
//      flash
// 
//       Flash the tile so that the user knows the tap was register but nothing will happen.
//

- (void)flash
{   
    if([self.date isToday]){
        _todayBGColor = kWhiteColor;
        _todayTextColor = kBlackColor;
        [self setNeedsDisplay];
    }
   self.layer.borderColor = [UIColor colorWithRed:0.6f green:0.06f blue:0.67f alpha:0.8].CGColor;
   self.layer.borderWidth = 2.0f;
    
}

// --------------------------------------------------------------------------------------------
//      restoreBackgroundColor
// 
//       The inverse of flashTile, this is called at the end of the flash duration
//       to restore the tile's origianl background color.
//
- (void)restoreBackgroundColor
{
    if([self.date isToday]){
        _todayBGColor = kTileTodayBGColor;
        _todayTextColor = kTileTodayTextColor;
        [self setNeedsDisplay];
    }else{
        self.backgroundColor = [UIColor colorWithCGColor:kTileNormalBGColor];
    }
        self.layer.borderWidth = 0.0f;
}

- (CGColorRef)textTopColor { return _textTopColor; }
- (void)setTextTopColor:(CGColorRef)color
{
    if (color != _textTopColor) {
        CGColorRelease(_textTopColor);
        _textTopColor = CGColorRetain(color);
    }
}

- (CGColorRef)textBottomColor { return _textBottomColor; }
- (void)setTextBottomColor:(CGColorRef)color
{
    if (color != _textBottomColor) {
        CGColorRelease(_textBottomColor);
        _textBottomColor = CGColorRetain(color);
    }
}
- (void)setCheckmarked:(BOOL)c
{
    checkmarked = c;
}

- (void)dealloc
{
    [_date release];
    [_text release];
   // CGColorRelease(_todayBGColor);
   // CGColorRelease(_todayTextColor);
    CGColorRelease(_textTopColor);
    CGColorRelease(_textBottomColor);
    [super dealloc];
}

@end
