//
//  MCWordDataDao.h
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCWordDataDao : NSObject

// Dao object 생성
// 싱글톤으로 DAO object 생성
+ (id) sharedDao;

// CATEGORY 데이터를 조회한다.
// MCCategory 객체 리스트를 반환한다.
- (NSArray*) categories;

// BOOK 데이터를 조회하다.
// 특정 category id에 속해있는 BOOK 정보를 조회한다.
// MCBook 객체 리스트를 반환한다.
- (NSArray*) booksForCategory:(NSInteger) categoryId;

// GROUP 데이터를 조회하다.
// 특정 book id에 속해있는 GROUP 정보를 조회한다.
// MCGroup 객체 리스트를 반환한다.
- (NSArray*) groupsForBook:(NSInteger) bookId;

// WORD 데이터를 조회하다.
// 특정 group id에 속해있는 WORD 정보를 조회한다.
// MCWord 객체 리스트를 반환한다.
- (NSArray*) wordsForGroup:(NSInteger) groupId;

// 특정 GROUP속 WORD를 암기 했는지 여부를 기록한다.
- (void) setMemoriedFlag:(BOOL)flag wordId:(NSInteger) wordId groupId:(NSInteger)groupId;

// word group에서 암기 혹은 미암기 단어 수 
- (NSInteger) countOfWordsMemorized:(BOOL) memoried groupId:(NSInteger)groupId;

// word group 속의 단어 갯수
- (NSInteger) countOfWordsInGroup:(NSInteger)groupId;

// 단어리스트를 DB에 추가한다.
// 추가할 단어목록인 |words|를 |category|의 |book| 객체에 속하는 
// |group|에 속하는 단어를 추가한다.
- (BOOL) addWords:(NSArray*)words 
            group:(NSString*)group 
             book:(NSString*)book 
         category:(NSString*)category;

@end
