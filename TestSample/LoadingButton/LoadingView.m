//
//  LoadingView.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/20.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "LoadingView.h"

const CGFloat TIME_INTERVAL = 0.1;

@interface LoadingView()

@property LoadingLayer *loadingLayer;

@property LoadingStartLayer *loadingStartLayer;

@property (nonatomic, assign)IBInspectable CGFloat lineWidth;

@property (nonatomic, assign)IBInspectable CGFloat duration;

@property (nonatomic, assign)IBInspectable UIColor *lineColor;

@property CGFloat timeLeft;

@property NSTimer *timer;

@property BOOL timerRunning;

@property CGFloat diameter;

@end

IB_DESIGNABLE
@implementation LoadingView

@synthesize delegate;

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 外层loading
    self.loadingLayer = [LoadingLayer layer];
    self.loadingLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.loadingLayer];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    self.diameter = MIN(width, height) / 2;
    
    self.loadingLayer.bounds = CGRectMake(0, 0, self.diameter, self.diameter);
    self.loadingLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.loadingLayer.lineWidth = self.lineWidth;
    self.loadingLayer.lineColor = self.lineColor;
    
    // 内层startloading
    CGFloat innerDiameter = self.diameter / 2;
    self.loadingStartLayer = [LoadingStartLayer layer];
    self.loadingStartLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.loadingStartLayer];
    self.loadingStartLayer.bounds = CGRectMake(0, 0, innerDiameter, innerDiameter);
    self.loadingStartLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)countDown:(id)sender
{
    self.timeLeft -= TIME_INTERVAL;
    self.loadingLayer.progress = 1 - self.timeLeft / self.duration;
    if (self.timeLeft <= 0) {
        [self stop];
    }
}

- (void)startAnimation
{
    [self reset];
    [self start];
}

- (void)reset
{
    CGFloat innerDiameter = self.diameter / 2;
    self.loadingStartLayer.bounds = CGRectMake(0, 0, innerDiameter, innerDiameter);
    self.timeLeft = self.duration;
}

- (void)start
{
    CGFloat innerDiameter = self.diameter - self.lineWidth * 2;
    self.loadingStartLayer.bounds = CGRectMake(0, 0, innerDiameter, innerDiameter);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    self.timerRunning = YES;
}

- (void)stopAnimation
{
    [self stop];
}

- (void)stop
{
    if (self.timerRunning) {
        [self.timer invalidate];
        self.timer = nil;
        [self animationDidStop];
        self.timerRunning = NO;
    }
}

- (void)animationDidStop
{
    if (delegate) {
        CGFloat totalTime = self.duration - self.timeLeft;
        [delegate loadingViewEnd:totalTime];
    }
}

@end
