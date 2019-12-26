//
//  RecordAudio.m
//  TestSample
//
//  Created by Violet Deng on 2019/12/24.
//  Copyright © 2019 Violet Deng. All rights reserved.
//

#import "RecordAudio.h"

@interface RecordAudio()
{
    AVAudioRecorder *recorder;
    
    NSString *audioFolderPath;
    
    NSString *currentFilePath;
    
    NSFileManager *fileManager;
}

@property (strong, nonatomic)  AVAudioPlayer *player;

@end

@implementation RecordAudio

static RecordAudio *_instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    }) ;
    
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [RecordAudio shareInstance];
}

- (nonnull id)copyWithZone:(struct _NSZone *)zone
{
    return [RecordAudio shareInstance];
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return [RecordAudio shareInstance];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                             NSUserDomainMask,
                                             YES) objectAtIndex: 0];
        audioFolderPath = [documentPath stringByAppendingPathComponent:@"audios"];
        
        fileManager = [[NSFileManager alloc] init];
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
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                         [NSNumber numberWithFloat:44100.0],                 AVSampleRateKey,
                                                                         [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey,
                                                                         [NSNumber numberWithInt:1],                         AVNumberOfChannelsKey,
                                                                         [NSNumber numberWithInt:AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                                                         nil];
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (!recorder) {
        return error;
    }
    [recorder record];
    
    return nil;
}

- (NSString *)getFilePath
{
    return currentFilePath;
}

- (NSString *)generateAudioFilePathWithDate: (NSDate*)date
                                    andExt: (NSString*)ext {
    NSInteger timeStamp = [[NSNumber numberWithDouble:
                            [date timeIntervalSince1970]] integerValue];
    
    return [NSString stringWithFormat: @"%@/%li.%@", audioFolderPath,
            timeStamp, ext];
}

- (void)stop
{
    if ([recorder isRecording]) {
        [recorder stop];
    }
}

- (BOOL)play
{
    if ([fileManager fileExistsAtPath:currentFilePath]) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:currentFilePath] error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
        return [self.player play];
    }
    return NO;
}

@end
