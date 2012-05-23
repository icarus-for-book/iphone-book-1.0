//
//  IntroLayer.m
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

#import "IntroLayer.h"
#import "SoundManager.h"


@implementation IntroLayer

@synthesize introImage;
@synthesize monkeyImage;

-(void)startGamePlay {
	CCLOG(@"Intro complete, asking Game Manager to start the Game play");
    // 원숭이 애니메이션 중지
    [self.monkeyImage stopAllActions];
    // Intro 배경 음악 중지
    [[SoundManager mySoundManager] stopBackgroundMusic];  
    // 첫번째 게임 화면으로 이동
	[[GameManager myGameManager] runSceneWithID:kLevel1Scene];    
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CCLOG(@"Touches received, skipping intro");
    
    [self removeChildByTag:1 cleanup:YES];
    [self startGamePlay];
}


- (void)startParticles {
    particleType++;
	if (particleType == ParticleTypes_MAX)
	{
		particleType = 0;
	}

    [self removeChildByTag:1 cleanup:YES];
        
        CCParticleSystem* system;
        
        switch (particleType)
        {
            case ParticleTypeExplosion:
                system = [CCParticleExplosion node];
                break;
            case ParticleTypeFire:
                system = [CCParticleFire node];
                break;
            case ParticleTypeFireworks:
                system = [CCParticleFireworks node];
                break;
            case ParticleTypeFlower:
                system = [CCParticleFlower node];
                break;
            case ParticleTypeGalaxy:
                system = [CCParticleGalaxy node];
                break;
            case ParticleTypeMeteor:
                system = [CCParticleMeteor node];
                break;
            case ParticleTypeRain:
                system = [CCParticleRain node];
                break;
            case ParticleTypeSmoke:
                system = [CCParticleSmoke node];
                break;
            case ParticleTypeSnow:
                system = [CCParticleSnow node];
                break;
            case ParticleTypeSpiral:
                system = [CCParticleSpiral node];
                break;
            case ParticleTypeSun:
                system = [CCParticleSun node];
                break;
                
            default:
                // do nothing
                break;
        }
        
        [self addChild:system z:1 tag:1];
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// Accept touch input
		self.isTouchEnabled = YES;
	        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
		self.introImage = [CCSprite spriteWithFile:@"intro.jpg"];
		[introImage setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:introImage];
        
        // 원숭이 이미지 출력
		self.monkeyImage = [CCSprite spriteWithFile:@"monkey1.png"];
		[monkeyImage setPosition:ccp(70, screenSize.height/2)];
		[self addChild:monkeyImage];
        
        // 원숭이 애니메이션 시작
        CCAnimation *monkeyAnimation = [CCAnimation animation];
        [monkeyAnimation setDelay:0.3f];
        for (int frameNumber=1; frameNumber < 8; frameNumber++) {
            CCLOG(@"Adding image monkey%d.png to the monkeyAnimation.",frameNumber);
            [monkeyAnimation addFrameWithFilename:
            [NSString stringWithFormat:@"monkey%d.png",frameNumber]];
        }
    
        // Particle 효과 주기 
 		id animationAction = [CCAnimate actionWithAnimation:monkeyAnimation restoreOriginalFrame:NO];
        CCCallFunc *callAction = [CCCallFunc actionWithTarget:self selector:@selector(startParticles)];
		id monkeySequence = [CCSequence actions:animationAction,callAction, nil];
		
		[self.monkeyImage runAction:[CCRepeatForever actionWithAction:monkeySequence]];
        
	}    
    return self;
}


#pragma mark -
#pragma mark Memory Release

- (void) dealloc {
    [self.introImage release];
    [self.monkeyImage release];
    [super dealloc];
}


@end
