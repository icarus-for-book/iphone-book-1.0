//
//  StorageInfo.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 8..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "StorageInfo.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation StorageInfo

@synthesize usedSize = _usedSize;
@synthesize freeSize = _freeSize;

- (id)init
{
    self = [super init];
    if (self) {
        [self update];
    }
    
    return self;
}


- (unsigned long long)totalSize
{
    return _freeSize + _usedSize;
}

- (void) update
{
    NSFileManager* fMgr = [ NSFileManager defaultManager ];	
    NSError* pError = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSDictionary* pDict = [fMgr attributesOfFileSystemForPath:documentDirectory error:&pError];
    NSNumber* pNumAvail = (NSNumber*)[pDict objectForKey:NSFileSystemFreeSize];
    NSNumber* pNumFull = (NSNumber*)[pDict objectForKey:NSFileSystemSize];
    
    _freeSize = [pNumAvail unsignedLongLongValue];
    _usedSize = [pNumFull unsignedLongLongValue] - _freeSize;
    
}

- (NSUInteger)countOfSongs
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    return query.items.count;
}


@end
