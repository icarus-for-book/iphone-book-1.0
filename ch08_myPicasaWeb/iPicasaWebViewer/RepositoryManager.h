//
//  RepositoryManager.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 28..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Data를 repository( file system )에 기록하는 Class.
@interface RepositoryManager : NSObject {
    NSString *_hostPath;
}

@property(nonatomic, retain) NSString *hostPath;


// initialize
- (id) initWithTags:(NSArray*)tags;

// write data
- (NSString*) writeData:(NSData*) data;
- (NSString*) writeData:(NSData*) data asName:(NSString*) name;

// read data
- (NSData*) readWithName:(NSString*)name;

// list up file names
- (NSArray*) filesInRepository;
- (NSArray*) directorysInRepository;

// reset datas
- (void) deleteRepository;
- (void) deleteDatas;
- (void) deleteDataWithName:(NSString*) name;

@end