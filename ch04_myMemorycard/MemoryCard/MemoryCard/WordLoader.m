//
//  WordLoader.m
//  MemoryCard
//
//  Created by jinni on 11. 8. 2..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "WordLoader.h"
#import "TouchXML.h"
#import "MCWordDataDao.h"
#import "SBJsonParser.h"

@interface WordLoader()

// xml 단어장 읽기
- (void) loadXMLContentsForURL:(NSURL*)url;
// plist 단어장 읽기
- (void) loadPlistContentsForURL:(NSURL*)url;
// JSON 단어장 읽기
- (void) loadJSONContentsForURL:(NSURL*)url;


@end

@implementation WordLoader

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

// xml 단어장 읽기
- (void) loadXMLContentsForURL:(NSURL*)url
{
    // xml load
    CXMLDocument *wordParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:NULL];
    
    // group으로 검색을 해서 필요한 정보를 추출하자.
    NSArray *groupNodes = [wordParser nodesForXPath:@"//group" error:nil];
    
    for (CXMLElement *groupNode in groupNodes)
    {
        NSString *groupTitle = [[groupNode nodeForXPath:@"title" error:nil] stringValue];
        NSString *bookTitle = [[groupNode nodeForXPath:@"../../title" error:nil]stringValue];
        NSString *categoryTitle = [[groupNode nodeForXPath:@"../../../../title" error:nil] stringValue];
        
        NSArray *wordNodes = [groupNode nodesForXPath:@"words/word" error:nil];
        
        NSMutableArray *parsedWords = [[NSMutableArray alloc] initWithCapacity:wordNodes.count];
        for (CXMLElement *wordNode in wordNodes)
        {
            MCWord *word = [[MCWord alloc] init];
            
            word.level = [[[wordNode nodeForXPath:@"level" error:nil] stringValue] intValue];
            word.wordclass = [[wordNode nodeForXPath:@"wordclass" error:nil] stringValue];
            word.meanning = [[wordNode nodeForXPath:@"meanning" error:nil] stringValue];
            word.spelling = [[wordNode nodeForXPath:@"spelling" error:nil] stringValue];
            word.example = [[wordNode nodeForXPath:@"example" error:nil] stringValue];
            word.pronunciation = [[wordNode nodeForXPath:@"pronunciation" error:nil] stringValue];
            
            [parsedWords addObject:word];
            [word release];
        }
        
        MCWordDataDao *dao = [MCWordDataDao sharedDao];
        [dao addWords:parsedWords group:groupTitle book:bookTitle category:categoryTitle];
        
        [parsedWords release];
    }    
}
// plist 단어장 읽기
- (void) loadPlistContentsForURL:(NSURL*)url
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:url];
    NSLog(@"dic = %@", dic);

    NSString *categoryTitle = [dic objectForKey:@"title"];
    for(NSDictionary *book in [dic objectForKey:@"books"])
    {
        NSString *bookTitle = [book objectForKey:@"title"];
        
        for (NSDictionary *group in [book objectForKey:@"groups"])
        {
            NSString *groupTitle = [group objectForKey:@"title"];

            NSMutableArray *parsedWords = [[NSMutableArray alloc] initWithCapacity:100];
            
            for (NSDictionary *info in [group objectForKey:@"words"])
            {
                MCWord *word = [[MCWord alloc] init];
                
                word.level = [[info objectForKey:@"level"] intValue];
                word.wordclass = [info objectForKey:@"wordclass"];
                word.meanning = [info objectForKey:@"meanning"];
                word.spelling = [info objectForKey:@"spelling"];
                word.example = [info objectForKey:@"example"];
                word.pronunciation = [info objectForKey:@"pronunciation"];
                
                [parsedWords addObject:word];
                [word release];
            }
            
            MCWordDataDao *dao = [MCWordDataDao sharedDao];
            [dao addWords:parsedWords group:groupTitle book:bookTitle category:categoryTitle];
            
            [parsedWords release];

        }
                               
    }
}
// JSON 단어장 읽기
- (void) loadJSONContentsForURL:(NSURL*)url
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dic = [parser objectWithData:[NSData dataWithContentsOfURL:url]];
    [parser release];
    NSString *categoryTitle = [dic objectForKey:@"title"];
    for(NSDictionary *book in [dic objectForKey:@"books"])
    {
        NSString *bookTitle = [book objectForKey:@"title"];
        
        for (NSDictionary *group in [book objectForKey:@"groups"])
        {
            NSString *groupTitle = [group objectForKey:@"title"];
            
            NSMutableArray *parsedWords = [[NSMutableArray alloc] initWithCapacity:100];
            
            for (NSDictionary *info in [group objectForKey:@"words"])
            {
                MCWord *word = [[MCWord alloc] init];
                
                word.level = [[info objectForKey:@"level"] intValue];
                word.wordclass = [info objectForKey:@"wordclass"];
                word.meanning = [info objectForKey:@"meanning"];
                word.spelling = [info objectForKey:@"spelling"];
                word.example = [info objectForKey:@"example"];
                word.pronunciation = [info objectForKey:@"pronunciation"];
                
                [parsedWords addObject:word];
                [word release];
            }
            
            MCWordDataDao *dao = [MCWordDataDao sharedDao];
            [dao addWords:parsedWords group:groupTitle book:bookTitle category:categoryTitle];
            
            [parsedWords release];
            
        }
        
    }
}


// 주어진 URL의 단어를 DB에 넣기
- (void) loadContentsForURL:(NSURL*)url
{
    NSString *ext = [url pathExtension];
    if ([[ext lowercaseString] isEqualToString:@"xml"]) {
        [self loadXMLContentsForURL:url];
    } else if ([[ext lowercaseString] isEqualToString:@"plist"]) {
        [self loadPlistContentsForURL:url];
    } else if ([[ext lowercaseString] isEqualToString:@"json"]) {
        [self loadJSONContentsForURL:url];
    }
}

// 로드할 단어 목록 가져오기
- (NSArray*) listForLoadableLocal
{
    
}

// 로드할 단어 목록 가져오기
- (NSArray*) listForLoadableServer
{
    
}

@end
