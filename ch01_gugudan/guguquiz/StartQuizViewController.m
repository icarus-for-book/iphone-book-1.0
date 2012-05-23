//
//  StartQuizViewController.m
//  guguquiz
//
//  Created by Jinsub Ahn on 11. 11. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "StartQuizViewController.h"
#import "QuizViewController.h"

@implementation StartQuizViewController

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
    
    self.title = @"구구단 퀴즈";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onStart:(id)sender {
    QuizViewController *viewController = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.totalQuiz = 10;
    [viewController release];
}
@end
