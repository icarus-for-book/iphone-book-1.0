//
//  MCWordDataDao.m
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MCWordDataDao.h"
#import <sqlite3.h>

@implementation MCWordDataDao


+ (id) sharedDao
{
    static MCWordDataDao *dao = nil;
    if (dao == nil) {
        @synchronized([MCWordDataDao class])
        {
            if(dao == nil)
            {
                dao = [[MCWordDataDao alloc]init];
            }
        }
    }
    
    return dao;
}

+ (NSString*) dbpath
{
    static NSString *copiedDB = nil;
    
    if (copiedDB == nil)
    {
        copiedDB = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                          NSUserDomainMask, 
                                                          YES) lastObject] 
                     stringByAppendingPathComponent:@"worddata.sqlite"] retain];
    }
    return copiedDB;
    
}

// 앱번들 속에 있는 DB파일을 파일 추가가 불가능하기 때문에
// DB파일을 Documents 및으로 복사한다.
// 참고로, initialize는 프로그램이 실행되는 초기에 한번 실행되는
// 함수 있다.
+ (void) initialize
{

    NSFileManager *fileMgr = [NSFileManager defaultManager];

    NSString *copiedDB = [self dbpath];
    
    // Bundle이 있는 기본 DB 파일을 Documents로 복사해서 
    // DB파일을 변경할 수 있도록 한다.
    // Bundle속 데이터는 변경이 불가능한다.
    if ( ! [fileMgr fileExistsAtPath:copiedDB] )
    {
        // copy db from resource to document path
        
        NSString *srcDb = [[NSBundle mainBundle] pathForResource:@"worddata" ofType:@"sqlite"];
        BOOL success = [fileMgr copyItemAtPath:srcDb toPath:copiedDB error: NULL];
        if( !success )
        {
            NSLog(@"error copy db");
        }
    }
}


- (id)init
{
    self = [super init];
    return self;

}

- (NSArray*) categories 
{
    sqlite3 *database = NULL;
    
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:10];
    
    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
		
        //2. SQL문을 분석해서 내부 명령으로 변환
		const char *sql = "select CATEGORYID, TITLE from CATEGORY";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
            //3. SQL문 실행.
            // slite3_step을 복수번 실행하면 SELECT문의 경우 각 레코드를 이동한다.
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				//4. 조회된 값을 MCCategory 객체에 기록한다.
				MCCategory *category = [[MCCategory alloc] init];
                category.categoryId = sqlite3_column_int(selectstmt, 0);
                category.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				[ret addObject:category];
                [category release];
			}
		}
        // 5. SQL명령을 제거한다.
        sqlite3_finalize(selectstmt);

	}
    // 6. DB 파일을 닫는다.
    if(database) sqlite3_close(database);
    
    return [ret autorelease];
}


- (NSArray*) booksForCategory:(NSInteger) categoryId
{
    sqlite3 *database = NULL;
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:10];

    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
		
        //2. SQL문을 분석해서 내부 명령으로 변환
		NSString *query = [NSString stringWithFormat:@"select BOOKID, TITLE from BOOK where CATEGORYID = '%d'", categoryId];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &selectstmt, NULL) == SQLITE_OK) {

            //3. SQL문 실행.
            // slite3_step을 복수번 실행하면 SELECT문의 경우 각 레코드를 이동한다.
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				//4. 조회된 값을 MCBook 객체에 기록한다.
				MCBook *obj = [[MCBook alloc] init];
                obj.bookId = sqlite3_column_int(selectstmt, 0);
                obj.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				[ret addObject:obj];
                [obj release];
			}
		}
        // 5. SQL명령을 제거한다.
        sqlite3_finalize(selectstmt);

	}    
    // 6. DB 파일을 닫는다.
    if(database) sqlite3_close(database);

    return [ret autorelease];    
}

- (NSArray*) groupsForBook:(NSInteger) bookId
{
    sqlite3 *database = NULL;
    
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:10];
    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
		
        //2. SQL문을 분석해서 내부 명령으로 변환
		NSString *query = [NSString stringWithFormat:@"select GROUPID, TITLE from 'GROUP' where BOOKID = '%d'", bookId];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //4. 조회된 값을 리턴하려는 객체에 복사한다.
				MCGroup *obj = [[MCGroup alloc] init];
                obj.groupId = sqlite3_column_int(selectstmt, 0);
                obj.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
				[ret addObject:obj];
                [obj release];
			}
		}
        // 5. SQL명령을 제거한다.
        sqlite3_finalize(selectstmt);

	}

    if(database) sqlite3_close(database);

    
    return [ret autorelease];    
}

- (NSArray*) wordsForGroup:(NSInteger) groupId
{
    sqlite3 *database = NULL;
    
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:10];
    
    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
		
        //2. SQL문을 분석해서 내부 명령으로 변환
		NSString *query = [NSString stringWithFormat:@"select WORDID, LEVEL,WORDCLASS,MEANING, SPELLING,EXAMPLE, PRONUNCIATION, MEMORIZED from WORD,WORDGROUP where WORD.WORDID = WORDGROUP.WORD and WORDGROUP.'GROUP' = '%d'", groupId];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &selectstmt, NULL) == SQLITE_OK) {
            
            //3. SQL문 실행.
            // slite3_step을 복수번 실행하면 SELECT문의 경우 각 레코드를 이동한다.
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //4. 조회된 값을 리턴하려는 객체에 복사한다.
				MCWord *obj = [[MCWord alloc] init];
                
                [obj propertyWillInit];
				
                obj.wordid = sqlite3_column_int(selectstmt, 0);
                obj.level = sqlite3_column_int(selectstmt, 1);
                obj.wordclass = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                obj.meanning = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                obj.spelling = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
                obj.example = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
                obj.pronunciation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)];
                obj.memorized = sqlite3_column_int(selectstmt, 7) == 0 ? NO : YES;
                
                [obj propertyDidInit];
                
				[ret addObject:obj];
                [obj release];
			}
		}
        // 5. SQL명령을 제거한다.
        sqlite3_finalize(selectstmt);

	}
    
    if(database) sqlite3_close(database);

    
    return [ret autorelease];    
}

- (NSInteger) countOfWordsInGroup:(NSInteger)groupId
{
    sqlite3 *database = NULL;
    
    NSInteger ret = 0;
    
    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
		
        //2. SQL문을 분석해서 내부 명령으로 변환
		NSString *query = [NSString stringWithFormat:@"select count(*) from WORD,WORDGROUP where WORD.WORDID = WORDGROUP.WORD and WORDGROUP.'GROUP' = %d", groupId];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &selectstmt, NULL) == SQLITE_OK) {
            //3. SQL문 실행.
            // slite3_step을 복수번 실행하면 SELECT문의 경우 각 레코드를 이동한다.
			if(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //4. 조회된 값을 리턴하려는 객체에 복사한다.
                ret = sqlite3_column_int(selectstmt, 0);
			}
		}
        
        // 5. SQL명령을 제거한다.
        sqlite3_finalize(selectstmt);
	}
    
    if(database) sqlite3_close(database);

    
    return ret;    
}

- (NSInteger) countOfWordsMemorized:(BOOL) memoried groupId:(NSInteger)groupId
{
    sqlite3 *database = NULL;

    NSInteger ret = 0;
    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
		
        //2. SQL문을 분석해서 내부 명령으로 변환
		NSString *query = [NSString stringWithFormat:@"select count(*) from WORD,WORDGROUP where WORD.WORDID = WORDGROUP.WORD and WORDGROUP.'GROUP' = %d and MEMORIZED = %d",groupId,memoried ? 1: 0 ];
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &selectstmt, NULL) == SQLITE_OK) {
            //3. SQL문 실행.
            // slite3_step을 복수번 실행하면 SELECT문의 경우 각 레코드를 이동한다.
			if(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //4. 조회된 값을 리턴하려는 객체에 복사한다.
                ret = sqlite3_column_int(selectstmt, 0);
			}
		}
        // 5. SQL명령을 제거한다.
        sqlite3_finalize(selectstmt);

	}
    
    if(database) sqlite3_close(database);

    return ret;    
}

- (void) setMemoriedFlag:(BOOL)flag wordId:(NSInteger) wordId groupId:(NSInteger)groupId
{
    sqlite3 *database = NULL;
    
    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *query = [NSString stringWithFormat:@"update WORDGROUP set MEMORIZED = '%d' where WORDGROUP.WORD = '%d' and WORDGROUP.'GROUP' = '%d'", 
                           flag ? 1 : 0,
                           wordId,
                           groupId];
        char *zErr = NULL;
        //2. SQL문 실행.
        // sqlite3_exec는 SQL문을 분석해서 실행하고 결과를 조회하는 단계를 한번에 할 수 있는 
        // 함수
        int sqlret = sqlite3_exec(database, [query UTF8String], NULL, NULL, &zErr);
        if (sqlret != SQLITE_OK && zErr != NULL) {
            NSLog(@"error in setMemoriedFlag : %s", zErr);
            sqlite3_free(zErr);
        }
	}
    // 3. DB 파일을 닫는다.
    if(database) sqlite3_close(database);
}

- (BOOL) addWords:(NSArray*)words group:(NSString*)group book:(NSString*)book category:(NSString*)category
{
    sqlite3 *database = NULL;
    char *zErr;
    NSString* query;
    
    // 1. DB 파일 열기
	if (sqlite3_open([[MCWordDataDao dbpath] UTF8String], &database) == SQLITE_OK) {
    
        do{
            // transaction 시작.
            if( sqlite3_exec(database, "BEGIN", NULL, NULL, &zErr) !=SQLITE_OK )
            {
                NSLog(@"addWords error : %s", zErr);
                sqlite3_free(zErr);
                break;
            }
            
            // add category
            query = [NSString stringWithFormat:@"insert into CATEGORY(title) values ('%@');", category];
            if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &zErr) != SQLITE_OK) {
                NSLog(@"addWords error : %s", zErr);
                sqlite3_free(zErr);
            }
            
            // add book
            query = [NSString stringWithFormat:@"insert into BOOK(title,CATEGORYID) values ('%@', (select CATEGORYID from CATEGORY where title = '%@'));", book, category];
            if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &zErr) != SQLITE_OK) {
                NSLog(@"addWords error : %s", zErr);
                sqlite3_free(zErr);
            }
            
            // add group
            query = [NSString stringWithFormat:@"insert into 'GROUP'(title,BOOKID) values ('%@', (select BOOKID from BOOK where title = '%@'));", group,book];
            if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &zErr) != SQLITE_OK) {
                NSLog(@"addWords error : %s", zErr);
                sqlite3_free(zErr);
            }
            
            int groupid = sqlite3_last_insert_rowid(database);
            
            // add words
            for (MCWord *word in words)
            {
                const char* sql = "insert into WORD(LEVEL, WORDCLASS, MEANING, SPELLING, EXAMPLE, PRONUNCIATION) values (?, ?, ?, ?,?, ?);";
                sqlite3_stmt *stmt;
                //2. SQL문을 분석해서 내부 명령으로 변환
                if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
                    
                    sqlite3_bind_int(stmt, 1, word.level);
                    sqlite3_bind_text(stmt, 2, [word.wordclass UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [word.meanning UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [word.spelling UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [word.example UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [word.pronunciation UTF8String], -1, SQLITE_STATIC);
                    sqlite3_step(stmt);
                    sqlite3_finalize(stmt);
                }
                

                // add wordgroup
                query = [NSString stringWithFormat:@"insert into WORDGROUP('GROUP','WORD') values ('%d', last_insert_rowid());", groupid];
                if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &zErr) != SQLITE_OK) {
                    NSLog(@"addWords *insert wordgroup) error : %s", zErr);
                    sqlite3_free(zErr);
                }
                
            }
            
            if( sqlite3_exec(database, "COMMIT", NULL, NULL, &zErr) !=SQLITE_OK )
            {
                NSLog(@"addWords error : %s", zErr);
                sqlite3_free(zErr);
                break;
            }

            
        }while(false);
		
	}
    // 6. DB 파일을 닫는다.
    if(database) sqlite3_close(database);
    return NO;
}

@end
