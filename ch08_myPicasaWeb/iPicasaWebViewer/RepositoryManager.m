
//  RepositoryManager.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 28..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepositoryManager.h"

@interface RepositoryManager()

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation RepositoryManager

@synthesize hostPath = _hostPath;

// initialize
- (id) initWithTags:(NSArray*)tags
{
    self = [super init];
    if(self)
    {
        NSURL *doc = [self applicationDocumentsDirectory];
        self.hostPath = [[NSURL URLWithString:[NSString pathWithComponents:tags] relativeToURL: doc] path];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (! [fileManager fileExistsAtPath:self.hostPath] )
        {
            [fileManager createDirectoryAtPath:self.hostPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }

    }
    return self;
}

        

// write data
- (NSString*) writeData:(NSData*) data
{
    NSString *tempPath = [self.hostPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%f", [[NSDate date]timeIntervalSince1970]]];

    NSError *error;
    [data writeToFile:tempPath options:NSDataWritingAtomic error:&error];
    
    if (error != nil) {
        return nil;
    }
    
    return tempPath;
}

- (NSString*) writeData:(NSData*) data asName:(NSString*) name
{
    NSString *tempPath = [self.hostPath stringByAppendingPathComponent:name];
    
    NSError *error=nil;
    [data writeToFile:tempPath options:NSDataWritingAtomic error:&error];
    
    if (error != nil) {
        return nil;
    }
    
    return tempPath;
}

// read data
- (NSData*) readWithName:(NSString*)name
{
    return [NSData dataWithContentsOfFile:[self.hostPath stringByAppendingPathComponent:name]];
}

- (NSArray*) filesAndSubDirectorsInRepository
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.hostPath error:NULL];
    return contents;
}

// list up file names
- (NSArray*) filesInRepository
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.hostPath error:NULL];
    
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity: contents.count];

    for (NSString* path in contents)
    {
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:[self.hostPath stringByAppendingPathComponent:path] isDirectory:&isDir]) {
            if (!isDir) {
                [ret addObject:path];
            }
        }
    }
    
    return ret;
}

- (NSArray*) directorysInRepository
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:self.hostPath error:NULL];
    
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity: contents.count];
    
    for (NSString* path in contents)
    {
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:[self.hostPath stringByAppendingPathComponent:path] isDirectory:&isDir]) {
            if (isDir) {
                [ret addObject:path];
            }
        }
    }
    
    return ret;
}

// reset datas
- (void) deleteDatas
{
    NSArray *filesInRepository = [self filesAndSubDirectorsInRepository];
    
    for(NSString* file in filesInRepository)
    {
        [self deleteDataWithName:file];
    }
}

- (void) deleteRepository
{
    [self deleteDatas];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:self.hostPath error:NULL];
    
    
}

- (void) deleteDataWithName:(NSString*) name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if([fileManager fileExistsAtPath:[self.hostPath stringByAppendingPathComponent:name]])
    {
        [fileManager removeItemAtPath:[self.hostPath stringByAppendingPathComponent:name] error:NULL];
    }
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
