//
//  RecordAudio.h
//  TestSample
//
//  Created by Violet Deng on 2019/12/24.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface RecordAudio : NSObject

+ (instancetype)shareInstance;

- (void)requestRecordingPermission: (void(^) (BOOL))callback;

- (NSError *)start;

- (void)stop;

- (NSString *)getFilePath;

- (BOOL)play;

@end
