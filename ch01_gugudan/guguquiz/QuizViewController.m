//
//  QuizViewController.m
//  guguquiz
//
//  Created by Jinsub Ahn on 11. 11. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "QuizViewController.h"
#import "ResultViewController.h"

@implementation QuizViewController

@synthesize totalQuiz;
@synthesize correctAnswer;
@synthesize wrongAnswer;
@synthesize textAnswer;
@synthesize labelFirst;
@synthesize labelSecond;
@synthesize labelMark;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self putTheQuiz];
    [self.textAnswer becomeFirstResponder];
    
    // next button 
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"다음" style:UIBarButtonItemStyleDone target:self action:@selector(onCheckAnswerAndNext)];
    self.navigationItem.rightBarButtonItem = nextButton;
    [nextButton release];
    
    self.title = [NSString stringWithFormat:@"%d 문제", self.correctAnswer + self.wrongAnswer + 1];
    
}

- (void)viewDidUnload
{
    [self setLabelFirst:nil];
    [self setLabelSecond:nil];
    [self setTextAnswer:nil];
    [self setLabelMark:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    NSMutableArray *views = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
    if ([views count] > 1 && [[views objectAtIndex:[views count] - 2] isKindOfClass:[QuizViewController class]]) {
        // 이전 QuizViewController를 제거한다.
        [views removeObjectAtIndex:[views count] - 2];
        self.navigationController.viewControllers = views;
    }
    
    [views release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) putTheQuiz{
    
    int gugu_1 = arc4random() % 8 + 1;
    int gugu_2 = arc4random() % 8 + 1;
    
    labelFirst.text = [NSString stringWithFormat:@"%d", gugu_1];
    labelSecond.text = [NSString stringWithFormat:@"%d", gugu_2];
    
    numAnswer = gugu_1 * gugu_2;
}

- (void) onCheckAnswerAndNext
{
    if ([textAnswer.text intValue] == numAnswer) {
        self.correctAnswer++;
        self.labelMark.text = @"O";
    } else {
        self.wrongAnswer++;
        self.labelMark.text = @"X";
    }
    
    // animation
    self.labelMark.hidden = NO;
    self.labelMark.alpha = 0.0f;
    [UIView animateWithDuration:0.5f animations:^{
        
        self.labelMark.alpha = 1.0f;
    
    } completion:^(BOOL finished) {
        // 화면 전환
        if (self.totalQuiz == self.correctAnswer + self.wrongAnswer) {
            ResultViewController *viewController = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
            viewController.totalQuiz = self.totalQuiz;
            viewController.correctAnswer = self.correctAnswer;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        } else {
            QuizViewController *viewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
            viewController.totalQuiz = self.totalQuiz;
            viewController.correctAnswer = self.correctAnswer;
            viewController.wrongAnswer = self.wrongAnswer;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }

        self.title = @"구구단 퀴즈";
        
    }];
    
}

- (void)dealloc {
    [labelFirst release];
    [labelSecond release];
    [textAnswer release];
    [labelMark release];
    [super dealloc];
}
@end
