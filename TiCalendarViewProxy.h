/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"

@interface TiCalendarViewProxy : TiViewProxy {

@private
    NSMutableArray* dates;
}

@property(nonatomic, retain) NSArray* dates;
@property(nonatomic, retain) NSNumber* month;

- (void) setDates: (NSArray*) datesArray;
- (void) setMonth: (NSNumber*) value;
- (void) setCalendarColor: (id) color;
- (id) saveEvent: (id) args;
- (void) moveMonthNext: (NSNumber*)intMonth;
- (void) jumpToday: (NSNumber*)fakeNum;
- (void) moveMonthBack: (NSNumber*)intMonth;
@end
