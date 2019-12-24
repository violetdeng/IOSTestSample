//
//  RecordVideoViewController.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/24.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "RecordVideoViewController.h"


@interface RecordVideoViewController() {
    RecordVideo *recorder;
}

@end

@implementation RecordVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    recorder = [[RecordVideo alloc] init];
}

- (IBAction)onStart:(id)sender {
    [recorder requestRecordingPermission:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [self->recorder start];
                if (error) {
                    NSLog(@"start record error is %@", error);
                }
            });
        } else {
            // alert
            UIAlertController* alertController = [UIAlertController
                                                  alertControllerWithTitle: @"无权限"
                                                  message: @"请在设置中打开权限"
                                                  preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction* alertAction = [UIAlertAction actionWithTitle: @"确定"
                                                                  style: UIAlertActionStyleDefault
                                                                handler: nil];
            
            [alertController addAction: alertAction];
            
            [self presentViewController: alertController
                               animated: YES
                             completion: nil];
        }
    }];
}

- (IBAction)onStop:(id)sender {
    [recorder save];
}

@end
