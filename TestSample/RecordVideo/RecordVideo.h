//
//  RecordVideo.h
//  TestSample
//
//  Created by Violet Deng on 2019/12/24.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface RecordVideo : NSObject


- (void)requestRecordingPermission: (void(^) (BOOL))callback;

- (NSError*)start;

- (void)save;

@end