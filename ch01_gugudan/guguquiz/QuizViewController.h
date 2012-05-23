//
//  QuizViewController.h
//  guguquiz
//
//  Created by Jinsub Ahn on 11. 11. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartQuizViewController;

@interface QuizViewController : UIViewController {
    UILabel *labelFirst;
    UILabel *labelSecond;
    UITextField *textAnswer;
    
    NSInteger numAnswer;
    
    StartQuizViewController *mainViewController;
}


@property NSInteger totalQuiz;
@property NSInteger correctAnswer;
@property NSInteger wrongAnswer;
@property (nonatomic, retain) IBOutlet UITextField *textAnswer;

@property (nonatomic, retain) IBOutlet UILabel *labelFirst;
@property (nonatomic, retain) IBOutlet UILabel *labelSecond;
@property (retain, nonatomic) IBOutlet UILabel *labelMark;


- (void) putTheQuiz;
- (void) onCheckAnswerAndNext;

@end
