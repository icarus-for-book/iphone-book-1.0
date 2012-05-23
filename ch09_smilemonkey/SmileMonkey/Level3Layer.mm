//
//  Level3Layer.m
//  SmileMonkey
//
//  Created by cjk on 12. 1. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
// 이 게임의 소스코드에 대한 라이센스는 MIT 방식으로 완전 무료입니다.
// 공개 소스코드와 공개 음원을 사용해 개발되었으며, 게임에 사용된 배경 이미지 및 유닛 이미지 일부에 대한
// 상업적인 사용은 허락하지 않습니다. 그 이외 모든 부분에 대해서는 상업적인 사용을 포함한 모든 권한을
// 오픈 소스 형태로 공개합니다. 
// 아래 URL에 있는 소스 코드 중 일부를 모듈을 사용해 개발된 게임입니다. 
// http://www.raywenderlich.com
// 게임에 사용된 음원은 
// http://www.rengoku-teien.com/ 에서 다운받아 사용하였습니다. 

#import "Level3Layer.h"
#import "SoundManager.h"


@implementation Level3Layer

@synthesize labelEnemies, pauseBtnSprite, pressPauseBtnSprite;


-(id) init
{
	if( (self=[super init])) {
		// 터치 사용이 가능하도록 설정
		self.isTouchEnabled = YES;
        
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Box2D 중력 설정, Sleep 모드 설정
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);		
		bool doSleep = true;
		
		// Box2D 화면 구성
		world = new b2World(gravity, doSleep);
		// 물리 엔진 적용
		world->SetContinuousPhysics(true);
		
		// 디버그 정보 출력 
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
        
		uint32 flags = 0;
        // 디버그 정보 출력 플래그
        /*
		flags += b2DebugDraw::e_shapeBit;
        flags += b2DebugDraw::e_jointBit;
        flags += b2DebugDraw::e_aabbBit;
        flags += b2DebugDraw::e_pairBit;
        flags += b2DebugDraw::e_centerOfMassBit;
         */
		m_debugDraw->SetFlags(flags);		

		// 배경 화면 설정 
        CCSprite *sprite = [CCSprite spriteWithFile:@"jungle.jpg"];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:-1];        
        
        // 탱크 왼쪽에 위치하는 원숭이
        sprite = [CCSprite spriteWithFile:@"monkey1.png"];
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(30.0f, FLOOR_HEIGTH+35);
        sprite.scale = 0.5;
        [self addChild:sprite z:0];
        
        // 대포 발사하는 몸체 
        sprite = [CCSprite spriteWithFile:@"tank.png"];
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(40.0f, FLOOR_HEIGTH-5);
        sprite.scale = 0.5;
        [self addChild:sprite z:2];

        self.pauseBtnSprite = [[CCSprite alloc] initWithFile:@"stop.png"];
        self.pauseBtnSprite.anchorPoint = CGPointZero;
        self.pauseBtnSprite.position = CGPointMake(420.0f, FLOOR_HEIGTH+250);
        self.pauseBtnSprite.visible = YES;
        [self addChild:self.pauseBtnSprite z:2];

        self.pressPauseBtnSprite = [[CCSprite alloc] initWithFile:@"play.png"];
        self.pressPauseBtnSprite.anchorPoint = CGPointZero;
        self.pressPauseBtnSprite.position = CGPointMake(420.0f, FLOOR_HEIGTH+250);
        self.pressPauseBtnSprite.visible = NO;   
        [self addChild:self.pressPauseBtnSprite z:2];
                
		// ground body 영역 설정
		b2BodyDef groundBodyDef;
        // 왼쪽 코너 설정 
		groundBodyDef.position.Set(0, 0); 
        // ground body 영역 적용    
		groundBody = world->CreateBody(&groundBodyDef);
		
        // Box2D 영역 설정 
		b2PolygonShape groundRect;		
		// 바닥 
		groundRect.SetAsEdge(b2Vec2(0,FLOOR_HEIGTH/PTM_RATIO), b2Vec2(screenSize.width*2.0f/PTM_RATIO,FLOOR_HEIGTH/PTM_RATIO));
		groundBody->CreateFixture(&groundRect,0);		
		// 천정
		groundRect.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width*2.0f/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundRect,0);		
		// 왼쪽 
		groundRect.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundRect,0);
		
        // 대포 포신 
        CCSprite *barrelBar = [CCSprite spriteWithFile:@"barrel.png"];
        [self addChild:barrelBar z:1];
        
      
        b2BodyDef barrelBarBodyDef;
        barrelBarBodyDef.type = b2_dynamicBody;
        barrelBarBodyDef.linearDamping = 1;
        barrelBarBodyDef.angularDamping = 1;
        barrelBarBodyDef.position.Set(200.0f/PTM_RATIO,(FLOOR_HEIGTH+90.0f)/PTM_RATIO);
        barrelBarBodyDef.userData = barrelBar;
        barrelBarBody = world->CreateBody(&barrelBarBodyDef);
        
        b2PolygonShape barRect;
        b2FixtureDef barRectDef;
        barRectDef.shape = &barRect;
        barRectDef.density = 0.5F;
        barRect.SetAsBox(10.0f/PTM_RATIO, 90.0f/PTM_RATIO);
        barrelBarFixture = barrelBarBody->CreateFixture(&barRectDef);
        
        b2RevoluteJointDef barrelJointDef;
        barrelJointDef.Initialize(groundBody, barrelBarBody, b2Vec2(180.0f/PTM_RATIO, FLOOR_HEIGTH/PTM_RATIO));
        barrelJointDef.enableMotor = true;
        barrelJointDef.enableLimit = true;
        barrelJointDef.motorSpeed  = -10;
        barrelJointDef.lowerAngle  = CC_DEGREES_TO_RADIANS(10);
        barrelJointDef.upperAngle  = CC_DEGREES_TO_RADIANS(80);
        barrelJointDef.maxMotorTorque = 900;        
        barrelBarJoint = (b2RevoluteJoint*)world->CreateJoint(&barrelJointDef);
 
        [self schedule: @selector(tick:)];
        [self performSelector:@selector(resetGame) withObject:nil afterDelay:0.3f];
        
        enemyContact = new EnemyContactListener();
        world->SetContactListener(enemyContact);
        
        // 문자열 출력
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Level3 Jungle Mission" fontName:@"Marker Felt" fontSize:32];
		[label setColor:ccc3(0,130,135)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);        
		[self addChild:label z:5];
        
        self.labelEnemies = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:25];
		[self.labelEnemies setColor:ccc3(250,120,0)];
		self.labelEnemies.position = ccp( 100, screenSize.height-25);
		[self addChild:self.labelEnemies z:5];
        
	}
	return self;
}

- (void)resetGame
{
    // 화면에 표시된 유닛을 새롭게 그림 
    if (unitItems)
    {
        for (NSValue *unitPointer in unitItems)
        {
            b2Body *unit = (b2Body*)[unitPointer pointerValue];
            CCNode *node = (CCNode*)unit->GetUserData();
            [self removeChild:node cleanup:YES];
            world->DestroyBody(unit);
        }
        [unitItems release];
        unitItems = nil;
    }
    
    // 타겟 지우고 새로 그리기 
    if (targets)
    {
        for (NSValue *bodyValue in targets)
        {
            b2Body *body = (b2Body*)[bodyValue pointerValue];
            CCNode *node = (CCNode*)body->GetUserData();
            [self removeChild:node cleanup:YES];
            world->DestroyBody(body);
        }
        [targets release];
        [enemies release];
        targets = nil;
        enemies = nil;
    }
    
    [self createUnitItems:5];  // 발사할 수 있는 유닛의 수
    [self createTargets];      // 화면에 표시할 타켓 수   
    [self displayEnemies];     // 적 유닛 표시 
   
    
    [self runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:1.5f position:CGPointMake(-480.0f, 0.0f)], 
                     [CCCallFuncN actionWithTarget:self selector:@selector(attachUnitItem)],
                     [CCDelayTime actionWithDuration:1.0f],
                     [CCMoveTo actionWithDuration:1.5f position:CGPointZero],
                     nil]];
}


- (void)createUnitItems:(NSInteger)cnt
{
    curUnitItem = 0;
    CGFloat pos = 62.0f;

    // 발사할 유닛을 추가 
    NSArray *bulletName = [NSArray arrayWithObjects:@"banana1.png", @"banana2.png", 
                            @"bottle.png", @"hat.png", @"pineapple.png", nil];    
    
    cnt = (cnt > [bulletName count])?[bulletName count]:cnt;
    
    if (cnt > 0)
    {
         unitItems = [[NSMutableArray alloc] initWithCapacity:cnt];
         CGFloat delta = (cnt > 1)?(50.0f / (cnt - 1)):0.0f;
        
        for (NSInteger i = 0; i <  cnt; i++, pos += delta) 
        {
            CCSprite *sprite = [CCSprite spriteWithFile:[bulletName objectAtIndex:i]];
            sprite.scale = 0.3;
            [self addChild:sprite z:2];
            
            b2BodyDef unitBodyDef;
            unitBodyDef.type = b2_dynamicBody;
            unitBodyDef.bullet = true;
            unitBodyDef.position.Set(pos/PTM_RATIO,(FLOOR_HEIGTH + 30.0f)/PTM_RATIO);
            unitBodyDef.userData = sprite;
            b2Body *bullet = world->CreateBody(&unitBodyDef);
            bullet->SetActive(false);
            
            b2CircleShape circle;
            circle.m_radius = 15.0/PTM_RATIO;
            
            b2FixtureDef unitShapeDef;
            unitShapeDef.shape = &circle;
            unitShapeDef.density = 0.8f;
            unitShapeDef.restitution = 0.2f;
            unitShapeDef.friction = 0.99f;
            bullet->CreateFixture(&unitShapeDef);
            
            [unitItems addObject:[NSValue valueWithPointer:bullet]];
        }
    }
}


- (BOOL)attachUnitItem
{
    if (curUnitItem < [unitItems count])
    {
        bulletBody = (b2Body*)[[unitItems objectAtIndex:curUnitItem++] pointerValue];
        bulletBody->SetTransform(b2Vec2(190.0f/PTM_RATIO,(155.0f+FLOOR_HEIGTH)/PTM_RATIO), 0.0f);
        bulletBody->SetActive(true);
        
        b2WeldJointDef weldJointDef;
        weldJointDef.Initialize(bulletBody, barrelBarBody, b2Vec2(230.0f/PTM_RATIO,(155.0f+FLOOR_HEIGTH)/PTM_RATIO));
        weldJointDef.collideConnected = false;
        
        bulletJoint = (b2WeldJoint*)world->CreateJoint(&weldJointDef);
        return YES;
    }
    return NO;
}


- (void)resetUnit
{
    [self displayEnemies];
    if ([enemies count] == 0)    
    {       
        // 게임 클리어할 때 호출  
        // 배경 음악 중지
        [[SoundManager mySoundManager] stopBackgroundMusic];  
        [[GameManager myGameManager] runSceneWithID:kEndScene];
    }
    else if ([self attachUnitItem])
    {
        // 원숭이 포신 앞으로 포커스 이동 
        [self runAction:[CCMoveTo actionWithDuration:2.0f position:CGPointZero]];
    }
    else
    {
        // 현재 레벨 게임 초기화 
        [self performSelector:@selector(resetGame) withObject:nil afterDelay:2.0f];
    }
}


// 블록 배치하기, 적 배치하기  
- (void)createTarget:(NSString*)imageName 
          atPosition:(CGPoint)position
            rotation:(CGFloat)rotation
            isCircle:(BOOL)isCircle
            isStatic:(BOOL)isStatic
             isEnemy:(BOOL)isEnemy
{
    CCSprite *sprite = [CCSprite spriteWithFile:imageName];
    [self addChild:sprite z:1];
    
    b2BodyDef bodyDef;
    bodyDef.type = isStatic?b2_staticBody:b2_dynamicBody;
    bodyDef.position.Set((position.x+sprite.contentSize.width/2.0f)/PTM_RATIO,
                         (position.y+sprite.contentSize.height/2.0f)/PTM_RATIO);
    bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
    bodyDef.userData = sprite;
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2FixtureDef boxDef;
    if (isCircle)  // 원 형태 표시
    {
        b2CircleShape circle;
        circle.m_radius = sprite.contentSize.width/2.0f/PTM_RATIO;
        boxDef.shape = &circle;
    }
    else
    {   // 정상 모형 표시
        b2PolygonShape boxShape;
        boxShape.SetAsBox(sprite.contentSize.width/2.0f/PTM_RATIO, sprite.contentSize.height/2.0f/PTM_RATIO);
        boxDef.shape = &boxShape;
    }
    
    if (isEnemy) // 적 유닛일 경우 
    {
        boxDef.userData = (void*)1;
        [enemies addObject:[NSValue valueWithPointer:body]];
    }
    
    boxDef.density = 0.5f;
    body->CreateFixture(&boxDef);
    
    [targets addObject:[NSValue valueWithPointer:body]];
}

- (void)createTargets
{
    [targets release];
    [enemies release];
    targets = [[NSMutableSet alloc] init];
    enemies = [[NSMutableSet alloc] init];
    
    // 첫 번째 블록
    [self createTarget:@"rock1.png" atPosition:CGPointMake(400.0, FLOOR_HEIGTH) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"rock1.png" atPosition:CGPointMake(400.0, FLOOR_HEIGTH+42) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"rock1.png" atPosition:CGPointMake(520.0, FLOOR_HEIGTH) rotation:90.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"wood1.png" atPosition:CGPointMake(400.0, FLOOR_HEIGTH+84) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"parrot.png" atPosition:CGPointMake(420.0, FLOOR_HEIGTH+103) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];     
    [self createTarget:@"rock3.png" atPosition:CGPointMake(500.0, FLOOR_HEIGTH+103) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"rock3.png" atPosition:CGPointMake(500.0, FLOOR_HEIGTH+144) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];    
    [self createTarget:@"tiger.png" atPosition:CGPointMake(515.0, FLOOR_HEIGTH+185) rotation:0.0f isCircle:NO isStatic:NO isEnemy:YES];
    
    // 두 번째 블록
    [self createTarget:@"squirrel.png" atPosition:CGPointMake(570.0, FLOOR_HEIGTH) rotation:0.0f isCircle:NO isStatic:NO isEnemy:YES];
    [self createTarget:@"wood3.png" atPosition:CGPointMake(630.0, FLOOR_HEIGTH) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"wood3.png" atPosition:CGPointMake(630.0, FLOOR_HEIGTH+42) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"wood3.png" atPosition:CGPointMake(630.0, FLOOR_HEIGTH+84) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"wood3.png" atPosition:CGPointMake(630.0, FLOOR_HEIGTH+126) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"wood2.png" atPosition:CGPointMake(615.0, FLOOR_HEIGTH+168) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"parrot.png" atPosition:CGPointMake(630.0, FLOOR_HEIGTH+209) rotation:0.0f isCircle:NO isStatic:NO isEnemy:YES]; 
    
    // 세 번째 블록
    [self createTarget:@"wood2.png" atPosition:CGPointMake(710.0, FLOOR_HEIGTH) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"wood2.png" atPosition:CGPointMake(720, FLOOR_HEIGTH+41) rotation:90.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"wood2.png" atPosition:CGPointMake(710.0, FLOOR_HEIGTH+125) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"squirrel.png" atPosition:CGPointMake(740.0, FLOOR_HEIGTH+166) rotation:0.0f isCircle:NO isStatic:NO isEnemy:YES];
    
    // 네 번째 블록
    [self createTarget:@"rock1.png" atPosition:CGPointMake(810.0, FLOOR_HEIGTH) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"rock4.png" atPosition:CGPointMake(815.0, FLOOR_HEIGTH+42) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO];
    [self createTarget:@"tiger.png" atPosition:CGPointMake(900.0, FLOOR_HEIGTH) rotation:0.0f isCircle:NO isStatic:NO isEnemy:YES];
}


-(BOOL) isTouchInsidePauseBtn:(CCSprite *)sprite withTouch:(UITouch *) touch 
{
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convert = [[CCDirector sharedDirector] convertToGL:location];
    CGFloat width = sprite.contentSize.width / 2;
    CGFloat height = sprite.contentSize.height / 2;
    
    CCLOG(@"%f + w,  %f - w,  %f + h,  %f - h", sprite.position.x + width, sprite.position.x - width,sprite.position.y + height,sprite.position.y - height );
    
    if(convert.x > (sprite.position.x + width)  ||
       convert.x < (sprite.position.x - width)  ||
       convert.y > (sprite.position.y + height) ||
       convert.y < (sprite.position.y - height)){
        return NO;
    }
    else {
        return YES;
    }
}

-(void) draw
{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);

	world->DrawDebugData();
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil) return;
    
    UITouch *touch = [touches anyObject];
    
    if(([self isTouchInsidePauseBtn:self.pauseBtnSprite withTouch:touch] == YES) ||
       ([self isTouchInsidePauseBtn:self.pressPauseBtnSprite withTouch:touch] == YES))
    {
        if (self.pauseBtnSprite.visible == YES) {
            [[CCDirector sharedDirector] pause];
            [[SoundManager mySoundManager] pauseBackgroundMusic];  
            self.pauseBtnSprite.visible = NO;
            self.pressPauseBtnSprite.visible = YES; 
            isGamePause = YES;
        }
        else
        {
            [[CCDirector sharedDirector] resume];
            [[SoundManager mySoundManager] resumeBackgroundMusic];   
            self.pauseBtnSprite.visible = YES;
            self.pressPauseBtnSprite.visible = NO;                
            isGamePause = NO;
        }
    }
    else
    {
        if(isGamePause == YES) return;
        
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
        if (locationWorld.x < barrelBarBody->GetWorldCenter().x + 50.0/PTM_RATIO)
        {
            b2MouseJointDef md;
            md.bodyA = groundBody;
            md.bodyB = barrelBarBody;
            md.target = locationWorld;
            md.maxForce = 2000;
        
            mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
            // 포신 잡아 당기는 효과음 추가하기 
            [[SoundManager mySoundManager] playSoundEffect:@"stretch"];

        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint == nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    mouseJoint->SetTarget(locationWorld);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil)
    {
        if (barrelBarJoint->GetJointAngle() >= CC_DEGREES_TO_RADIANS(30))
        {
            releasingBarrel = YES;
            // 총알 발사 효과음 추가하기 
            [[SoundManager mySoundManager] playSoundEffect:@"fire"];
        }
        
        world->DestroyJoint(mouseJoint);
        mouseJoint = nil;
    }
}

-(void) tick: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	world->Step(dt, velocityIterations, positionIterations);
	
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
    
    if (releasingBarrel && bulletJoint)
    {
        if (barrelBarJoint->GetJointAngle() <= CC_DEGREES_TO_RADIANS(10))
        {
            releasingBarrel = NO;
            world->DestroyJoint(bulletJoint);
            bulletJoint = nil;
            [self performSelector:@selector(resetUnit) withObject:nil afterDelay:5.0f];
        }
    }
    
    // 포탄 던질때 이동 화면
    if (bulletBody && bulletJoint == nil)
    {
        b2Vec2 position = bulletBody->GetPosition();
        CGPoint myPosition = self.position;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // 카메라 이동 
        if (position.x > screenSize.width / 2.0f / PTM_RATIO)
        {
            myPosition.x = -MIN(screenSize.width * 2.0f - screenSize.width, position.x * PTM_RATIO - screenSize.width / 2.0f);
            self.position = myPosition;
        }
    }
    
    // 충격 체크 
    std::set<b2Body*>::iterator pos;
    for(pos = enemyContact->contacts.begin(); 
        pos != enemyContact->contacts.end(); ++pos)
    {
        b2Body *body = *pos;        
        CCNode *contactNode = (CCNode*)body->GetUserData();
        CGPoint position = contactNode.position;
        [self removeChild:contactNode cleanup:YES];
        world->DestroyBody(body);
        
        [targets removeObject:[NSValue valueWithPointer:body]];
        [enemies removeObject:[NSValue valueWithPointer:body]];
        
        CCParticleSun* explosion = [[CCParticleSun alloc] initWithTotalParticles:200];
        explosion.autoRemoveOnFinish = YES;
        explosion.startSize = 10.0f;
        explosion.speed = 70.0f;
        explosion.anchorPoint = ccp(0.5f,0.5f);
        explosion.position = position;
        explosion.duration = 1.0f;
        [self addChild:explosion z:11];
        [explosion release];
         // 폭발 효과음 
        [[SoundManager mySoundManager] playSoundEffect:@"explodes"];        
    }
    
    enemyContact->contacts.clear();
}

-(void)displayEnemies
{
    NSString *enemiesStr = [[NSString alloc] initWithFormat:@"Enemies : %d", [enemies count]];
    [self.labelEnemies setString:enemiesStr];
    [enemiesStr release];
}

- (void) dealloc
{
    [unitItems release];
    [targets release];
    [enemies release];

	delete world;
	world = NULL;
	
    delete enemyContact;
    enemyContact = NULL;
    
	delete m_debugDraw;

    [super dealloc];
}


@end
