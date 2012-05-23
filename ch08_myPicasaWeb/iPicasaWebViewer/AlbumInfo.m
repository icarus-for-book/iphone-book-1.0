//
//  AlbumInfo.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 26..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AlbumInfo.h"
#import "AccountInfo.h"
#import "PhotoInfo.h"


@implementation AlbumInfo
@dynamic thumbnail;
@dynamic access;
@dynamic updated;
@dynamic published;
@dynamic summary;
@dynamic title;
@dynamic location;
@dynamic caching;
@dynamic albumid;
@dynamic numOfPhotos;
@dynamic account;
@dynamic photos;


- (void)addPhotosObject:(PhotoInfo *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"photos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"photos"] addObject:value];
    [self didChangeValueForKey:@"photos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePhotosObject:(PhotoInfo *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"photos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"photos"] removeObject:value];
    [self didChangeValueForKey:@"photos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPhotos:(NSSet *)value {    
    [self willChangeValueForKey:@"photos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"photos"] unionSet:value];
    [self didChangeValueForKey:@"photos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePhotos:(NSSet *)value {
    [self willChangeValueForKey:@"photos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"photos"] minusSet:value];
    [self didChangeValueForKey:@"photos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
