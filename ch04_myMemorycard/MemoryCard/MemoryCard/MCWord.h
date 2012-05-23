//
//  MCWord.h
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCGroup;

@interface MCWord : NSObject
{
    BOOL initProp;
}

@property(nonatomic, assign) NSInteger wordid;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, retain) NSString *wordclass;
@property(nonatomic, retain) NSString *meanning;
@property(nonatomic, retain) NSString *spelling;
@property(nonatomic, retain) NSString *example;
@property(nonatomic, retain) NSString *pronunciation;

@property(nonatomic, assign) BOOL memorized;
@property(nonatomic, assign) MCGroup *group;

// 초기화 할것이다.
- (void) propertyWillInit;
// 초기화 완료
- (void) propertyDidInit;

@end
