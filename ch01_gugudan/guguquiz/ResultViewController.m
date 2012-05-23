//
//  ResultViewController.m
//  guguquiz
//
//  Created by Jinsub Ahn on 11. 11. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"
#import "QuizViewController.h"

@implementation ResultViewController

@synthesize totalQuiz;
@synthesize correctAnswer;
@synthesize labelTotalQuiz;
@synthesize labelCorrectAnswer;
@synthesize labelMessage;

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
    
    self.labelTotalQuiz.text = [NSString stringWithFormat:@"%d", self.totalQuiz];
    self.labelCorrectAnswer.text = [NSString stringWithFormat:@"%d", self.correctAnswer];
    
    
    NSString *message = @"";
    float score = (float)correctAnswer / (float)totalQuiz * 100.0f;
    
    if (score == 100.0) {
        message = @"참 잘했어요. ";
    } else if (score > 80.0f){
        message = @"잘했어요. ";
    } else if (score > 60.0f){
        message = @"노력 좀 하셔야 겠네요. ";
    } else if (score > 40.0f){
        message = @"부모님이 걱정하십니다. ";
    } else if (score > 20.0f){
        message = @"아직 희망이 있어요.";
    } else {
        message = @"이를 어쩌나...";
    }
    
    self.labelMessage.text = message;
    
}

- (void)viewDidUnload
{
    [self setLabelTotalQuiz:nil];
    [self setLabelCorrectAnswer:nil];
    [self setLabelMessage:nil];
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

- (void)dealloc {
    [labelTotalQuiz release];
    [labelCorrectAnswer release];
    [labelMessage release];
    [super dealloc];
}
@end
