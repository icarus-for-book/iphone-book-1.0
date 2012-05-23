//
//  MCCategory.h
//  MemoryCard
//
//  Created by jinni on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCategory : NSObject

@property(nonatomic, retain) NSString *title;
@property(nonatomic, assign) NSInteger categoryId;

@property(nonatomic, readonly) NSArray *books;

@end
