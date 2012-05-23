//
//  MCGroup.m
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MCGroup.h"
#import "MCWordDataDao.h"

@implementation MCGroup

@synthesize book = _book;
@synthesize words = _words;
@synthesize title = _title;
@synthesize groupId = _groupId;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [_book release];
    [_words release];
    [_title release];
    [super dealloc];
}


- (NSArray*) words
{
    if (_words == nil) {
        MCWordDataDao *dao = [[MCWordDataDao alloc] init];
        
        NSArray *arrayOfWords = [dao wordsForGroup:_groupId];
        
        for (MCWord *word in arrayOfWords)
        {
            word.group = self;
        }
        
        [dao release];
        
        _words = [arrayOfWords retain];
    }
    
    return _words;
}

- (NSArray*) wordsOfMemorized
{
    NSMutableArray* memoWord = [[NSMutableArray alloc]initWithCapacity:self.words.count];
    
    for (MCWord *word in self.words)
    {
        if (word.memorized) {
            [memoWord addObject:word];
        }
    }
    
    return [memoWord autorelease];
}

- (NSArray*) wordsOfUnmemorized
{
    NSMutableArray* unmemoWord = [[NSMutableArray alloc]initWithCapacity:self.words.count];
    
    for (MCWord *word in self.words)
    {
        if (! word.memorized) {
            [unmemoWord addObject:word];
        }
    }
    
    return [unmemoWord autorelease];
    
}

// Group에 속하는 단어의 갯수
- (NSInteger) countOfWords
{
    MCWordDataDao *dao = [MCWordDataDao sharedDao];
    return [dao countOfWordsInGroup:self.groupId];
}

// 암기한 단어 수
- (NSInteger) countOfMemorized
{
    MCWordDataDao *dao = [MCWordDataDao sharedDao];
    return [dao countOfWordsMemorized:YES groupId:self.groupId];
    
}

// 암기하지 못한 단어의 수
- (NSInteger) countOfUnmemorized
{
    MCWordDataDao *dao = [MCWordDataDao sharedDao];
    return [dao countOfWordsMemorized:NO groupId:self.groupId];
    
}



@end
