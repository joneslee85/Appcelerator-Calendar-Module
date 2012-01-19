
#import "CheckmarkTile.h"
#import "KLColors.h"
#import "KLTile.h"
#import "KLDate.h"
@interface CheckmarkTile ()
- (CGFloat)thinRectangleWidth;
@end

@implementation CheckmarkTile

//@synthesize checkmarked;
@synthesize text;
- (CGFloat)thinRectangleWidth { return 1+floorf(0.02f * self.bounds.size.width); }        // 1pt width for 46pt tile width (2p

- (void)drawGradient:(CGRect)rect percentage:(CGFloat)percentToCover context:(CGContextRef)ctx
{
    CGFloat height = floorf(rect.size.height) + 4;
    CGFloat gradientLength = percentToCover * height;

    CGColorRef startColor = CreateRGB(0.51f, 0.22f, 0.61, 0.5f);  // black 40% opaque
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

- (void)drawText:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CGFloat width = self.bounds.size.width;
 //  CGFloat height = self.bounds.size.height;
    
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
        
            CGContextSetFillColorWithColor(ctx, kTilePinkColor);
        
            CGContextFillRect(ctx, self.bounds);  
        CGContextRestoreGState(ctx);  // get rid of the clip for the current letter        
    }
    CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect
{
   // [super drawRect:rect];
    
   // CGContextRef ctx = UIGraphicsGetCurrentContext();
   // Draw the checkmark if applicable

    if (self.checkmarked) {
       // unichar	character = 0x00B7; //Unicode checkmark
    //    CGContextSaveGState(ctx);
      //  CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.5f green:0.0f blue:1.0f alpha:1.0f] CGColor]);
      //  CGContextSetShadowWithColor(ctx, CGSizeMake(0.0f, -1.0f), 1.0f, [[UIColor blackColor] CGColor]);
        //NSString *checkmark = [NSString stringWithCharacters:&character length:1];
    //  [checkmark drawInRect:CGRectMake(4, 14, width-8, height-8) withFont: [UIFont boldSystemFontOfSize:0.85f*width] lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];
      //  [self drawGradient:rect percentage:1.0f context:ctx];
       // if([self.date isToday]){
            
      //  }else{
      //      [self drawText:ctx];
      //  }
        
        
        //Draw Gradient background for checked Tile
       // CGContextRestoreGState(ctx);
    }
}
/*
-(void) setCheckmarked:(BOOL) c
{
    checkmarked = c;
    [self setNeedsDisplay];
}
*/
/*-(BOOL) checkmarked
{
    return self.checkmarked;
}
 */
@end
