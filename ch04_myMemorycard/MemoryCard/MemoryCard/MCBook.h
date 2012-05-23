//
//  MCBook.h
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCCategory;

@interface MCBook : NSObject

@property(nonatomic, assign) MCCategory *category;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, assign) NSInteger bookId;
@property(nonatomic, readonly) NSArray *groups;

@end
