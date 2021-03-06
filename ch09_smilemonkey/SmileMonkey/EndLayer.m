//
//  EndLayer.m
//  SmileMonkey
//
//  Created by cjk on 12. 2. 26..
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

#import "EndLayer.h"
#import "SoundManager.h"

@implementation EndLayer

-(id) init
{
	if( (self=[super init])) {
		// 터치 사용이 가능하도록 설정
		self.isTouchEnabled = YES;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // 문자열 출력
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Thank you! All Clear!!!" fontName:@"Marker Felt" fontSize:40];
		[label setColor:ccc3(255,255,255)];
		label.position = ccp(screenSize.width/2, screenSize.height-50);        
		[self addChild:label z:0];
        
        // 원숭이 이미지 출력
		CCSprite *monkeyImage = [CCSprite spriteWithFile:@"monkey7.png"];
		[monkeyImage setPosition:ccp(screenSize.width/2, screenSize.height/2-20)];
		[self addChild:monkeyImage];
        
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    exit(0);
}


@end


