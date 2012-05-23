//
//  EnemyContactListener.m
//  SmileMonkey
//
//  Created by cjk on 12. 1. 28..
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

#include "EnemyContactListener.h"

EnemyContactListener::EnemyContactListener() : contacts()
{
}

EnemyContactListener::~EnemyContactListener()
{
}

void EnemyContactListener::BeginContact(b2Contact* contact)
{
}

void EnemyContactListener::EndContact(b2Contact* contact)
{
}

void EnemyContactListener::PreSolve(b2Contact* contact, 
                                 const b2Manifold* oldManifold)
{
}

void EnemyContactListener::PostSolve(b2Contact* contact, 
                                  const b2ContactImpulse* impulse)
{
    bool isAEnemy = contact->GetFixtureA()->GetUserData() != NULL;
    bool isBEnemy = contact->GetFixtureB()->GetUserData() != NULL;
    if (isAEnemy || isBEnemy)
    {
        int32 count = contact->GetManifold()->pointCount;
        float32 maxImpulse = 0.0f;
        for (int32 i = 0; i < count; ++i)
        {
            maxImpulse = b2Max(maxImpulse, impulse->normalImpulses[i]);
        }
        
        if (maxImpulse > 1.0f)
        {
            if (isAEnemy)
                contacts.insert(contact->GetFixtureA()->GetBody());
            if (isBEnemy)
                contacts.insert(contact->GetFixtureB()->GetBody());
        }
    }
}
