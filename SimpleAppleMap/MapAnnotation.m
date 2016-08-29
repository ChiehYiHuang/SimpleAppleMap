//
//  MapAnnotation.m
//  SimpleAppleMap
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

#pragma mark - Initialize
- (id)initWithLocation:(CLLocationCoordinate2D)aCoordinate2D {
    if ([super init]) {
        _coordinate = aCoordinate2D;
    }
    return self;
}

#pragma mark - Properties
- (void)setCoordinate:(CLLocationCoordinate2D)aCoordinate {
    _coordinate = aCoordinate;
}


@end
