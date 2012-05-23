//
//  ResultViewController.h
//  guguquiz
//
//  Created by Jinsub Ahn on 11. 11. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property NSInteger totalQuiz;
@property NSInteger correctAnswer;

@property (retain, nonatomic) IBOutlet UILabel *labelTotalQuiz;
@property (retain, nonatomic) IBOutlet UILabel *labelCorrectAnswer;
@property (retain, nonatomic) IBOutlet UILabel *labelMessage;

@end
