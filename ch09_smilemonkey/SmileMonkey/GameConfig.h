//
//  GameConfig.h
//  SmileMonkey
//
//  Created by cjk on 12. 1. 27..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//
// 이 게임의 소스코드에 대한 라이센스는 MIT 방식으로 완전 무료입니다.
// 공개 소스코드와 공개 음원을 사용해 개발되었으며, 게임에 사용된 배경 이미지 및 유닛 이미지 일부에 대한
// 상업적인 사용은 허락하지 않습니다. 그 이외 모든 부분에 대해서는 상업적인 사용을 포함한 모든 권한을
// 오픈 소스 형태로 공개합니다. 
// 아래 URL에 있는 소스 코드 중 일부를 모듈을 사용해 개발된 게임입니다. 
// http://www.raywenderlich.com
// 게임에 사용된 음원은 
// http://www.rengoku-teien.com/ 에서 다운받아 사용하였습니다. 

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

#define PTM_RATIO 32
#define FLOOR_HEIGTH    10.0f

// 화면 제어 
typedef enum {
    kUninitialized      =      0,
    kIntroScene         =    100,
    kLevel1Scene        =    200,
    kLevel2Scene        =    201,
    kLevel3Scene        =    202,
    kEndScene           =    203,    
} GameSceneTypes;




// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H

