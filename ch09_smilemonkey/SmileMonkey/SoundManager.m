//
//  SoundManager.m
//  SmileMonkey
//
//  Created by cjk on 12. 1. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//
// 이 게임의 소스코드에 대한 라이센스는 MIT 방식으로 완전 무료입니다.
// 공개 소스코드와 공개 음원을 사용해 개발되었으며, 게임에 사용된 배경 이미지 및 유닛 이미지 일부에 대한
// 상업적인 사용은 허락하지 않습니다. 그 이외 모든 부분에 대해서는 상업적인 사용을 포함한 모든 권한을
// 오픈 소스 형태로 공개합니다. 
// 아래 URL에 있는 소스 코드 중 일부를 모듈을 사용해 개발된 게임입니다. 
// http://www.raywenderlich.com
// 게임에 사용된 음원은 
// http://www.rengoku-teien.com/ 에서 다운받아 사용하였습니다. 

#import "SoundManager.h"


@implementation SoundManager

@synthesize backgroundMusic;
@synthesize soundEffect;

// Singleton
static SoundManager *_mySoundManager = nil;

+ (SoundManager *)mySoundManager {
    @synchronized([SoundManager class]) {
        // 아직 객체가 만들어지지 않았다면 init 메소드를 호출하여 새로 생성.
        if (!_mySoundManager)
            [[self alloc] init];        
        return _mySoundManager;
    }    
    // 컴파일러 에러를 막기위해 추가 
    return nil;
}

+ (id) alloc {
    @synchronized([SoundManager class]) {
        _mySoundManager = [super alloc];
        return _mySoundManager;
    }    
    // 컴파일러 에러를 막기위해 추가 
    return nil;
}

- (id) init {
    if( (self = [super init]) ) {
        // SystemSoundID를 보관할 Dictionary를 만든다. 
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] initWithCapacity:20];
        self.soundEffect = tmpDic;
        [tmpDic release];
    }
    
    return self;
}

- (void) createSoundEffect {
    NSArray *arrFileName = [NSArray arrayWithObjects:@"explodes", @"fire", @"stretch", nil];    
    SystemSoundID soundID;
    for (NSInteger i = 0; i < [arrFileName count]  ; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[arrFileName objectAtIndex:i] ofType:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
        NSNumber *num = [[NSNumber alloc] initWithUnsignedLong:soundID];
        [self.soundEffect setObject:num forKey:[arrFileName objectAtIndex:i]];
    }
}

- (void) playBackgroundMusic:(NSString*)fileName {
    @try {
            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
            self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];        
            self.backgroundMusic.numberOfLoops = -1;
            self.backgroundMusic.volume = 1.0;
            [self.backgroundMusic prepareToPlay];
            [self.backgroundMusic play];
    }@catch(NSException* e) {
        // 혹시 파일을 읽어들일 때 문제가 생길 경우를 대비하여 
        NSLog(@"Exception from playBackgroundMusic: %@ ", e);
    }
}

- (void) stopBackgroundMusic {
    @try {
        [self.backgroundMusic stop];
        [self.backgroundMusic release];
    }@catch(NSException* e) {
        // 혹시 파일을 읽어들일 때 문제가 생길 경우를 대비하여 
        NSLog(@"Exception from stopBackgroundMusic: %@ ", e);
    }
}

- (void) pauseBackgroundMusic {
    @try {
        [self.backgroundMusic pause];
    }
    @catch (NSException *e) {
        NSLog(@"Exception from pauseBackgroundMusic: %@ ", e);
    }
}

- (void) resumeBackgroundMusic {
    @try {
        [self.backgroundMusic play];
    }
    @catch (NSException *e) {
        NSLog(@"Exception from resumeBackgroundMusic: %@ ", e);
    }
}



- (void) playSoundEffect:(NSString*)fileName {
    @try {
        // 넘어온 파일 이름으로 만들어진 소리가 dictionary에 이미 들어있는지 확인한다.
        NSNumber *num = (NSNumber*) [self.soundEffect objectForKey:fileName];
        SystemSoundID soundID = [num unsignedLongValue];        
        // sound ID로 소리를 낸다.
        AudioServicesPlaySystemSound(soundID);
    }@catch(NSException* e) {
        // 혹시 파일을 읽어들일 때 문제가 생길 경우를 대비하여 
        NSLog(@"Exception from playSoundEffect: %@ ", e);
    }
}

- (void) dealloc {
     // 효과음 제거 
    if(self.soundEffect != nil && [self.soundEffect count] > 0) {
        NSArray *arrTmp = [self.soundEffect allValues];
        if(arrTmp != nil) {
            for(NSInteger i = 0; i < [arrTmp count]; i++) {
                NSNumber *num = (NSNumber*) [arrTmp objectAtIndex:i];
                if(num == nil)
                    continue;
                
                SystemSoundID soundID = [num unsignedLongValue];
                AudioServicesDisposeSystemSoundID(soundID);
            }
        }
    }
    [self.soundEffect release];
    
    if(self.backgroundMusic !=  nil)
       [self.backgroundMusic release];
    [super dealloc];
}

@end
