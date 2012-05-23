//
//  MCWord.m
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MCWord.h"
#import "MCWordDataDao.h"

@implementation MCWord

@synthesize wordid = _wordid;
@synthesize level = _level;
@synthesize wordclass = _wordclass;
@synthesize meanning = _meanning;
@synthesize spelling = _spelling;
@synthesize example = _example;
@synthesize pronunciation = _pronunciation;
@synthesize memorized = _memorized;
@synthesize group = _group;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc
{
    [_wordclass release];
    [_spelling release];
    [_example release];
    [_pronunciation release];
    [super dealloc];
}

- (void)setMemorized:(BOOL)memorized
{
    
    if (! initProp) {
        assert(self.group != nil);
        _memorized = memorized;
        MCWordDataDao *dao = [[MCWordDataDao alloc] init];
        [dao setMemoriedFlag:_memorized wordId:_wordid groupId:self.group.groupId];
        [dao release];
    } else {
        _memorized = memorized;
    }
}

// 초기화 할것이다.
- (void) propertyWillInit
{
    initProp = YES;
}
// 초기화 완료
- (void) propertyDidInit
{
    initProp = NO;
}
@end
