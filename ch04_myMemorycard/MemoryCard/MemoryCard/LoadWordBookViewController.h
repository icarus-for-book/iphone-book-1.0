//
//  LoadWordBookViewController.h
//  MemoryCard
//
//  Created by jinni on 11. 8. 2..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadWordBookViewController;

// 새로운 단어장이 추가되었을때 DB가 변경된다. 변경 내용을 통지하기 위한
// Delegate
@protocol LoadWordBookViewControllerDelegate <NSObject>

// WordBook의 데이터가 변경되었을때 호출
// 새로운 단어장이 추가되었을때
- (void)loadWordBookViewControllerDidChanged:(LoadWordBookViewController*)vc;

@end


@interface LoadWordBookViewController : UITableViewController

@property(nonatomic, retain) NSArray* filesInLocal;
@property(nonatomic, assign) id<LoadWordBookViewControllerDelegate> delegate;


@end
