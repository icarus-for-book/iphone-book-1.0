//
//  AccountInfo.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 26..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountInfo.h"
#import "AlbumInfo.h"


@implementation AccountInfo
@dynamic userid;
@dynamic passwd;
@dynamic albums;

- (void)addAlbumsObject:(AlbumInfo *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"albums" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"albums"] addObject:value];
    [self didChangeValueForKey:@"albums" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAlbumsObject:(AlbumInfo *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"albums" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"albums"] removeObject:value];
    [self didChangeValueForKey:@"albums" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAlbums:(NSSet *)value {    
    [self willChangeValueForKey:@"albums" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"albums"] unionSet:value];
    [self didChangeValueForKey:@"albums" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAlbums:(NSSet *)value {
    [self willChangeValueForKey:@"albums" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"albums"] minusSet:value];
    [self didChangeValueForKey:@"albums" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
