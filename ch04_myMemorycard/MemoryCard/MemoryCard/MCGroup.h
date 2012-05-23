//
//  MCGroup.h
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCBook;

@interface MCGroup : NSObject

@property (nonatomic, assign) MCBook *book;

@property (nonatomic, retain) NSArray *words;
@property (nonatomic, readonly) NSArray *wordsOfMemorized;
@property (nonatomic, readonly) NSArray *wordsOfUnmemorized;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSInteger groupId;

// Group에 속하는 단어의 갯수
- (NSInteger) countOfWords; 

// 암기한 단어 수
- (NSInteger) countOfMemorized;

// 암기하지 못한 단어의 수
- (NSInteger) countOfUnmemorized;

@end
