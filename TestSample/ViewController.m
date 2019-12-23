//
//  ViewController.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/20.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@end

@implementation ViewController

#pragma mark - user event
- (IBAction)onTapStartAnimation:(id)sender
{
    self.loadingView.delegate = self;
    [self.loadingView startAnimation];
}

- (IBAction)onTapStopAnimation:(id)sender
{
    [self.loadingView stopAnimation];
}

- (void)loadingViewEnd:(CGFloat)totalTime
{
    NSLog(@"total time is %f", totalTime);
}

@end
