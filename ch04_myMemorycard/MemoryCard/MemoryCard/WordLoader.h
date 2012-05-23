//
//  WordLoader.h
//  MemoryCard
//
//  Created by jinni on 11. 8. 2..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordLoader : NSObject

// 주어진 URL의 단어를 DB에 넣기
- (void) loadContentsForURL:(NSURL*)url;

// 로드할 단어 목록 가져오기
- (NSArray*) listForLoadableLocal;

// 로드할 단어 목록 가져오기
- (NSArray*) listForLoadableServer;


@end
