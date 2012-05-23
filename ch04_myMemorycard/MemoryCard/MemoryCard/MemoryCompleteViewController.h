//
//  MemoryCompleteViewController.h
//  MemoryComplete
//
//  Created by 진섭 안 on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoryCompleteViewController : UIViewController {
    UIView *_viewForSuccess;
    UIView *_viewForFail;
    UILabel *_labelBook;
    UILabel *_labelGroup;
    UILabel *_labelNumberOfDontKnow;
    UILabel *_labelNumberOfKnow;
    UILabel *_labelResult;
}

@property (nonatomic, retain) IBOutlet UILabel *labelBook;
@property (nonatomic, retain) IBOutlet UILabel *labelGroup;
@property (nonatomic, retain) IBOutlet UILabel *labelNumberOfDontKnow;
@property (nonatomic, retain) IBOutlet UILabel *labelNumberOfKnow;
@property (nonatomic, retain) IBOutlet UILabel *labelResult;

@property (nonatomic, retain) IBOutlet UIView *viewForFail;
@property (nonatomic, retain) IBOutlet UIView *viewForSuccess;

@property (nonatomic, retain) MCGroup *wordgroup;
@property (nonatomic, retain) NSArray *studiedWord;

// 암기할 Word Group List로 돌아가기
- (IBAction) onClickBackGroupList:(id)sender;
// 실패한 암기 목록 보기
- (IBAction) onClickViewWords:(id)sender;
// 다시 암기.
- (IBAction) onClickTryAgain:(id)sender;


@end
