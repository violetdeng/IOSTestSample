//
//  RecordVideo.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/24.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "RecordVideo.h"

@interface RecordVideo()
{
    AVAudioRecorder *recorder;
    
    NSString *audioFolderPath;
    
    NSString *currentFilePath;
}

@property (strong, nonatomic)  AVAudioPlayer *player;

@end

@implementation RecordVideo

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                             NSUserDomainMask,
                                             YES) objectAtIndex: 0];
        audioFolderPath = [documentPath stringByAppendingPathComponent:@"audios"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if (![fileManager fileExistsAtPath:audioFolderPath]) {
            [fileManager createDirectoryAtPath:audioFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    return self;
}

- (void)requestRecordingPermission: (void(^) (BOOL))callback {
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    
    if ([audioSession respondsToSelector: @selector(requestRecordPermission:)]) {
        [audioSession performSelector: @selector(requestRecordPermission:)
                           withObject: ^(BOOL granted) {
                               callback(granted);
                           }];
    }
}

- (NSError*)start
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    
    [audioSession setCategory: AVAudioSessionCategoryPlayAndRecord
                        error: &error];
    
    if (audioSession == nil) {
        return error;
    }
    
    [audioSession setActive: YES
                      error: nil];
    NSDate *nowDate = [NSDate date];
    currentFilePath = [self generateAudioFilePathWithDate:nowDate andExt:@"caf"];
    NSURL *url = [NSURL fileURLWithPath: currentFilePath];
//    NSDictionary *settings = @{
//        AVSampleRateKey: @8000.0f,                         // 采样率
//        AVFormatIDKey: @(kAudioFormatLinearPCM),           // 音频格式
//        AVLinearPCMBitDepthKey: @16,                       // 采样位数
//        AVNumberOfChannelsKey: @1,                         // 音频通道
//        AVEncoderAudioQualityKey: @(AVAudioQualityHigh)    // 录音质量
//    };
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                         [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                                                         [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                                                         [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                                                         [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                                                         nil];
    NSLog(@"record file url is %@", url);
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (!recorder) {
        return error;
    }
    NSLog(@"start to record");
//    [recorder prepareToRecord];
    [recorder record];
    
    return nil;
}

- (NSString*)generateAudioFilePathWithDate: (NSDate*)date
                                    andExt: (NSString*)ext {
    NSInteger timeStamp = [[NSNumber numberWithDouble:
                            [date timeIntervalSince1970]] integerValue];
    
    return [NSString stringWithFormat: @"%@/%li.%@", audioFolderPath,
            timeStamp, ext];
}

- (void)save
{
    [recorder stop];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSLog(@"record file is %@", currentFilePath);
    if ([fileManager fileExistsAtPath:currentFilePath]) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:currentFilePath] error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
        BOOL result = [self.player play];
        NSLog(@"ready to play %d", result);
    }
}

@end
