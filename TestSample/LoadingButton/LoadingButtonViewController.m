//
//  LoadingButtonViewController.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/24.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "LoadingButtonViewController.h"

@interface LoadingButtonViewController ()

@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@end

@implementation LoadingButtonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)handleEnteredBackground:(UIApplication *)application
{
    [self.loadingView stopTimer];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
