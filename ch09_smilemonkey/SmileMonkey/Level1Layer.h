//
//  Level1Layer.h
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

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "GameManager.h"
#import "EnemyContactListener.h"

@interface Level1Layer : CCLayer {
    // Box2d 환경 초기화 
   	b2World *world;
    // 디버그 모드 출력
	GLESDebugDraw *m_debugDraw;
    
    b2Body *groundBody;
    b2Body *barrelBarBody;
    b2Fixture *barrelBarFixture;
    
    b2RevoluteJoint *barrelBarJoint;
    b2MouseJoint *mouseJoint;
    
    
    // 총알 배열 
    NSMutableArray *unitItems;
    // 현재 사용중인 총알 
    int curUnitItem;
    
    b2Body *bulletBody;
    b2WeldJoint *bulletJoint;
    
    BOOL releasingBarrel;
    
    // 블록 
    NSMutableSet *targets;
    // 적 아이템 
    NSMutableSet *enemies;    
    // 적 남은 숫자
    CCLabelTTF *labelEnemies;
    // 게임 일시 정기 기능 
    BOOL isGamePause;    
    
    CCSprite *pauseBtnSprite;
    CCSprite *pressPauseBtnSprite;
    
    EnemyContactListener *enemyContact; 
}

@property (nonatomic, retain) CCLabelTTF *labelEnemies;
@property (nonatomic, retain) CCSprite *pauseBtnSprite;
@property (nonatomic, retain) CCSprite *pressPauseBtnSprite;

- (void)resetGame;                      // 게임 초기화  
- (void)createUnitItems:(NSInteger)cnt; // 화면에 총알 추가하기 
- (BOOL)attachUnitItem;                 // 총알 화면에 그리기  
- (void)createTargets;                  // 블록 및 적 배치하기  
- (void)displayEnemies;                 // 남은 적 숫자 표시하기  
- (BOOL)isTouchInsidePauseBtn:(CCSprite *)sprite withTouch:(UITouch *)touch; 


@end
