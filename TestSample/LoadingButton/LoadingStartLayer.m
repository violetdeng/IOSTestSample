//
//  LoadingStartLayer.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/23.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "LoadingStartLayer.h"


@implementation LoadingStartLayer

@dynamic hasStarted;
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"bounds"] || [key isEqualToString:@"hasStarted"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextAddEllipseInRect(ctx, self.bounds);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetAlpha(ctx, 0.3);
    CGContextFillPath(ctx);

    CGFloat maxDiameter = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat diameter = maxDiameter / 4 * 3;
    if (self.hasStarted) {
        diameter = maxDiameter / 2;
    }
    CGFloat radius = diameter / 2;
    CGContextAddEllipseInRect(ctx, CGRectMake(CGRectGetMidX(self.bounds) - radius, CGRectGetMidY(self.bounds) - radius, diameter, diameter));
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
}

@end
