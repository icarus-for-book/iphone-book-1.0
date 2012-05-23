//
//  MemoryCompleteViewController.m
//  MemoryComplete
//
//  Created by 진섭 안 on 11. 7. 29..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MemoryCompleteViewController.h"
#import "WordCardViewController.h"


@implementation MemoryCompleteViewController

@synthesize labelBook = _labelBook;
@synthesize labelGroup = _labelGroup;
@synthesize labelNumberOfDontKnow = _labelNumberOfDontKnow;
@synthesize labelNumberOfKnow = _labelNumberOfKnow;
@synthesize labelResult = _labelResult;
@synthesize viewForFail = _viewForFail;
@synthesize viewForSuccess = _viewForSuccess;
@synthesize wordgroup=_wordgroup;
@synthesize studiedWord=_studiedWord;

- (void)dealloc
{
    [_studiedWord release];
    [_wordgroup release];
    [_viewForSuccess release];
    [_viewForFail release];
    [_labelBook release];
    [_labelGroup release];
    [_labelNumberOfDontKnow release];
    [_labelNumberOfKnow release];
    [_labelResult release];
    [super dealloc];

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
    
    // 모든 단어를 암기 했다면 성공 화면을 아니면 실패 화면을 보여준다.
    if (self.wordgroup.wordsOfUnmemorized.count == 0) {
        self.viewForSuccess.hidden = NO;
        self.viewForFail.hidden = YES;
    } else 
    {
        self.viewForSuccess.hidden = YES;
        self.viewForFail.hidden = NO;
    }
    
    self.labelBook.text = self.wordgroup.book.title;
    self.labelGroup.text = self.wordgroup.title;
    
    int countOfMemoried = 0;
    for (MCWord *word in self.studiedWord)
    {
        if (word.memorized) {
            countOfMemoried++;
        }
    }
    int countOfUnmemoried = self.studiedWord.count - countOfMemoried;

    
    self.labelNumberOfDontKnow.text = [NSString stringWithFormat:@"%d", countOfUnmemoried];
    self.labelNumberOfKnow.text = [NSString stringWithFormat:@"%d", countOfMemoried];
    self.labelResult.text = [NSString stringWithFormat:@"총%d개의 단어를       모두 암기하였습니다.", self.studiedWord.count];
}


- (void)viewDidUnload
{
    [self setViewForSuccess:nil];
    [self setViewForFail:nil];
    [self setLabelBook:nil];
    [self setLabelGroup:nil];
    [self setLabelNumberOfDontKnow:nil];
    [self setLabelNumberOfKnow:nil];
    [self setLabelResult:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// 암기할 Word Group List로 돌아가기
- (IBAction) onClickBackGroupList:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
}

// 실패한 암기 목록 보기
- (IBAction) onClickViewWords:(id)sender
{
}

// 다시 암기.
- (IBAction) onClickTryAgain:(id)sender
{
    // 암기모드.
    WordCardViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
    
    viewController.words = [self.wordgroup wordsOfUnmemorized];
    viewController.curPos = 0;
    
    [self.navigationController popViewControllerAnimated:YES];

}


@end
