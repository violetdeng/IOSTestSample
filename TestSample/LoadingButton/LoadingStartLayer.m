//
//  LoadingStartLayer.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/23.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "LoadingStartLayer.h"


@implementation LoadingStartLayer

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"bounds"]) {
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
    
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2;
    CGContextAddEllipseInRect(ctx, CGRectMake(CGRectGetMidX(self.bounds) / 2, CGRectGetMidY(self.bounds) / 2, radius, radius));
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
    NSLog(@"loadingstartLayer drwa");
}

@end
