//
//  RecordAudioViewController.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/24.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "RecordAudioViewController.h"


@interface RecordAudioViewController() {
    
    BOOL isStartRecord;
    
    RecordAudio *recorder;
}

@end

@implementation RecordAudioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    recorder = [[RecordAudio alloc] init];
}

- (IBAction)onStart:(id)sender {
    [recorder requestRecordingPermission:^(BOOL granted) {
        if (granted) {
            // 异步 不影响UI操作
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                // 耗时的操作
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // 更新界面
//                });
//            });
            
            if (self->isStartRecord) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self->isStartRecord = YES;
                
                NSError *error = [self->recorder start];
                if (error) {
                    [self alert:@"出错了" message:@"开启录音失败"];
                    NSLog(@"start record error is %@", error);
                }
            });
        } else {
            [self alert:@"无权限" message:@"请在设置中打开权限"];
        }
    }];
}

- (IBAction)onStop:(id)sender {
    [self stopRecord];
}

- (void)stopRecord
{
    if (isStartRecord) {
        isStartRecord = NO;
        [recorder stop];
    }
}

- (IBAction)onPlay:(id)sender {
    [self stopRecord];
    if (![recorder play]) {
        [self alert:@"出错了" message:@"播放录音失败"];
    }
}

- (void)alert:(NSString *)title message:(NSString *)message
{
    // alert
    UIAlertController* alertController = [UIAlertController
                                          alertControllerWithTitle: title
                                          message: message
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* alertAction = [UIAlertAction actionWithTitle: @"确定"
                                                          style: UIAlertActionStyleDefault
                                                        handler: nil];
    
    [alertController addAction: alertAction];
    
    [self presentViewController: alertController
                       animated: YES
                     completion: nil];
}

@end
