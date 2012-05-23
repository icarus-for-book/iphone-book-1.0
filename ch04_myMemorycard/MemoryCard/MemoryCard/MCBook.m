//
//  MCBook.m
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MCBook.h"
#import "MCWordDataDao.h"

@implementation MCBook

@synthesize bookId = _bookId;
@synthesize title = _title;
@synthesize groups = _groups;
@synthesize category = _category;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [_title release];
    [super dealloc];
}

- (NSArray*) groups
{
    if (_groups == nil) {
        MCWordDataDao *dao = [[MCWordDataDao alloc] init];
        
        NSArray *arrayOfGroup = [dao groupsForBook:_bookId];
        
        for (MCGroup *group in arrayOfGroup)
        {
            group.book = self;
        }
        [dao release];
        
        _groups = [arrayOfGroup retain];
    }
    
    return _groups;
}


@end
