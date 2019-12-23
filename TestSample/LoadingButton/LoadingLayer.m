//
//  LoadingLayer.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/20.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "LoadingLayer.h"

@implementation LoadingLayer

@dynamic progress;
@dynamic lineWidth;
@dynamic lineColor;
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"] || [key isEqualToString:@"lineWidth"] || [key isEqualToString:@"lineColor"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - self.lineWidth / 2;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    // O
    CGFloat originStart = M_PI * 7 / 2;
    CGFloat originEnd = M_PI * 2;
    CGFloat currentOrigin = originStart - (originStart - originEnd) * self.progress;
    
    currentOrigin = - M_PI / 2;

    // D
    CGFloat destStart = M_PI * 3;
    destStart = - M_PI / 2;
    CGFloat destEnd = 0;
    destEnd = M_PI * 3 / 2;
    CGFloat currentDest = destStart - (destStart - destEnd) * self.progress;

    // 外部底框
//    UIBezierPath *centerPath = [UIBezierPath bezierPath];
//    [centerPath addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
//    CGContextAddPath(ctx, centerPath.CGPath);
//    CGContextSetLineWidth(ctx, self.lineWidth);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
//    CGContextStrokePath(ctx);
//    CGContextAddEllipseInRect(ctx, self.bounds);
//    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextSetAlpha(ctx, 0.5);
//    CGContextFillPath(ctx);
//    
    // 外部进度框
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle: currentOrigin endAngle:currentDest clockwise:YES];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextStrokePath(ctx);
}

@end
