//
//  MCCategory.m
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MCCategory.h"
#import "MCWordDataDao.h"

@implementation MCCategory

@synthesize  categoryId = _categoryId;
@synthesize  title = _title;
@synthesize books=_books;

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
    [_books release];
    [super dealloc];
}

- (NSArray*) books
{
    if (_books == nil) {
        MCWordDataDao *dao = [[MCWordDataDao alloc] init];
        NSArray *arrayOfBook = [dao booksForCategory:_categoryId];
        
        for (MCBook *book in arrayOfBook)
        {
            book.category = self;
        }
        [dao release];
        
        _books = [arrayOfBook retain];
    }
    
    return _books;
}

@end
