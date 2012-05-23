//
//  WordGroupViewController.h
//  MemoryCard
//
//  Created by 진섭 안 on 11. 7. 30..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemCellView;

@interface WordGroupViewController : UITableViewController < UIAlertViewDelegate >

// table에 표시한 data
@property (nonatomic, retain) NSArray *groups;
// custom table view 생성을 위한 임시 변수
@property (nonatomic, retain) IBOutlet ItemCellView *itemCell;
// Nib 파일 로드를 위한 객체
@property (nonatomic, retain) UINib *labelCellNib;

// 학습 시작
// 여기서 학습 모드로 화면 전환을 수행한다.
- (void) startStudy:(MCGroup*) group;

@end
