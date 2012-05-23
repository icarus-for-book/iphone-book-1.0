//
//  WordCardViewController.h
//  MemoryCard
//
//  Created by 진섭 안 on 11. 7. 30..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordCardViewController : UIViewController
{
    
    UIProgressView *_processBar;
    UILabel *_labelPronouce;
    
    NSInteger countOfKnow;
    NSInteger countOfDontKnow;
}

@property (nonatomic, retain) MCGroup *wordgroup;
@property (nonatomic, assign) NSInteger curPos;
@property (nonatomic, retain) NSArray *words;

@property (nonatomic, retain) IBOutlet UILabel *labelCountOfKnow;
@property (nonatomic, retain) IBOutlet UILabel *labelCountOfDontKnow;
@property (nonatomic, retain) IBOutlet UILabel *labelSpell;
@property (nonatomic, retain) IBOutlet UILabel *meaning;
@property (nonatomic, retain) IBOutlet UILabel *labelCurrentPos;
@property (nonatomic, retain) IBOutlet UIProgressView *processBar;
@property (nonatomic, retain) IBOutlet UILabel *labelPronouce;

- (IBAction)onBack:(id)sender;
- (IBAction)onPrevWord;
- (IBAction)onNextWord;
- (IBAction)onSetKnown:(id)sender;
- (IBAction)onSetUnknow:(id)sender;

// 학습 종료
- (IBAction)onCompleted;

// private method
- (void) updateMemoryPage;
- (void) registerGestureRecognizer;

@end
