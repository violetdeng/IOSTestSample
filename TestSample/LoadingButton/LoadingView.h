//
//  LoadingView.h
//  TestSample
//
//  Created by Violet Deng on 2019/12/20.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingLayer.h"
#import "LoadingStartLayer.h"

@protocol LoadingViewDelegate

- (void)loadingViewEnd:(CGFloat)totalTime;

@end

@interface LoadingView : UIButton

@property (nonatomic, assign) id<LoadingViewDelegate> delegate;

- (void)startAnimation;

- (void)stopAnimation;

@end
