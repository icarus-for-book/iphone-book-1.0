//
//  GameManager.m
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

#import "GameManager.h"             // 게임 화면 관리


#import "IntroScene.h"              // 초기 로딩 화면  
#import "Level1Scene.h"             // 첫 번째 레벨
#import "Level2Scene.h"             // 두 번째 레벨 
#import "Level3Scene.h"             // 세 번째 레벨 
#import "EndScene.h"                // 게임 종료 화면 


@implementation GameManager

static GameManager* _myGameManager = nil;        

// Singletons 처리
+(GameManager*)myGameManager {
    @synchronized([GameManager class])                             
    {
        if(!_myGameManager)                                    
            [[self alloc] init]; 
        return _myGameManager;                                 
    }
    return nil; 
}

+(id) alloc{
    @synchronized([GameManager class]){
        _myGameManager = [super alloc];
        return _myGameManager;        
    }
    return nil;
}


// 초기화
-(id) init {
    self = [super init];
    if(self != nil) {
        NSLog(@"GameManager Sigleton Initialize!");
        currentScene = kUninitialized;
        [[SoundManager mySoundManager] createSoundEffect];
    }
    return self;
}



-(void)runSceneWithID:(GameSceneTypes)sceneName {
    id showScene = nil;
    switch (sceneName) {
        case kIntroScene:            
            currentScene = kIntroScene;
            [[SoundManager mySoundManager] playBackgroundMusic:@"intro"];            
            showScene = [IntroScene node];            
            break;
        case kLevel1Scene:
            currentScene = kLevel1Scene;            
            [[SoundManager mySoundManager] playBackgroundMusic:@"level1"];            
            showScene = [Level1Scene node];
            break;
        case kLevel2Scene:  
            currentScene = kLevel2Scene;               
            [[SoundManager mySoundManager] playBackgroundMusic:@"level2"];            
            showScene = [Level2Scene node];
            break;
        case kLevel3Scene:
            currentScene = kLevel3Scene;               
            [[SoundManager mySoundManager] playBackgroundMusic:@"level3"];            
            showScene = [Level3Scene node];
            break;
        case kEndScene:
            [[SoundManager mySoundManager] playBackgroundMusic:@"end"];                  
            showScene = [EndScene node];
            break;
        default:
            CCLOG(@"화면 전환에 문제가 발생했습니다.");
            return;            
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        // 화면이 없으면 만들고 
        [[CCDirector sharedDirector] runWithScene:showScene];        
    } else {        
        // 화면이 있으면 화면 변경 
        [[CCDirector sharedDirector] replaceScene:showScene];
    }
    
}

@end
