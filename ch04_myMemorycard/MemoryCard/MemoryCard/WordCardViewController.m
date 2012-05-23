//
//  WordCardViewController.m
//  MemoryCard
//
//  Created by 진섭 안 on 11. 7. 30..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "WordCardViewController.h"
#import "MemoryCompleteViewController.h"

@implementation WordCardViewController

@synthesize words=_words;
@synthesize labelSpell = _labelSpell;
@synthesize meaning = _meaning;
@synthesize labelCurrentPos = _labelCurrentPos;
@synthesize processBar = _processBar;
@synthesize labelPronouce = _labelPronouce;
@synthesize wordgroup=_wordgroup;
@synthesize curPos = _curPos;
@synthesize labelCountOfKnow = _labelCountOfKnow;
@synthesize labelCountOfDontKnow = _labelCountOfDontKnow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _curPos = 0;
    }
    return self;
}

- (void)dealloc
{
    [_labelCountOfKnow release];
    [_labelCountOfDontKnow release];
    [_wordgroup release];
    [_words release];
    [_labelSpell release];
    [_labelCurrentPos release];
    [_meaning release];
    [_processBar release];
    [_labelPronouce release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self updateMemoryPage];
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setLabelSpell:nil];
    [self setMeaning:nil];
    [self setLabelCurrentPos:nil];
    [self setProcessBar:nil];
    [self setLabelPronouce:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onPrevWord {
    
    if (_curPos > 0) {
        _curPos--;
        [self updateMemoryPage];
    }
}

- (IBAction)onNextWord {
    if (self.words.count > _curPos + 1) {
        _curPos++;
        [self updateMemoryPage];
    } else {
        [self onCompleted];
    }
}

- (IBAction)onSetKnown:(id)sender
{
    MCWord *word = [self.words objectAtIndex:_curPos];
    word.memorized = YES;
    countOfKnow++;
    [self onNextWord];
}

- (IBAction)onSetUnknow:(id)sender
{
    countOfDontKnow++;
    [self onNextWord];
}

- (void)updateMemoryPage
{
    MCWord *word = [self.words objectAtIndex:_curPos];
    
    self.labelSpell.text = word.spelling;
    self.meaning.text = word.meanning;
    self.labelPronouce.text = word.pronunciation;
    self.labelCurrentPos.text = [NSString stringWithFormat:@"%d/%d", _curPos + 1, self.words.count];
    
    self.labelCountOfKnow.text = [NSString stringWithFormat:@"%d", countOfKnow];
    self.labelCountOfDontKnow.text = [NSString stringWithFormat:@"%d", countOfDontKnow];
    
    
    [self.processBar setProgress: ( (float)_curPos + 1.0f ) / [self.words count]];
}

- (void)onSwipeFrom:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left");
        [self onNextWord];
    } else if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self onPrevWord];
    } 
    
}

- (IBAction)onCompleted
{
    MemoryCompleteViewController *viewController = [[MemoryCompleteViewController alloc] initWithNibName:@"MemoryCompleteViewController" bundle:nil];
    viewController.wordgroup = self.wordgroup;
    viewController.studiedWord = self.words;
    [self.navigationController pushViewController:viewController animated:NO];
    [viewController release];
}


- (void) registerGestureRecognizer
{
    /*
    Create and configure the four recognizers. Add each to the view as a gesture recognizer.
    */
    UISwipeGestureRecognizer *recognizer;

    /*
    Create a swipe gesture recognizer to recognize right swipes (the default).
    We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.
    */
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeFrom:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];

    /*
    Create a swipe gesture recognizer to recognize left swipes.
    Keep a reference to the recognizer so that it can be added to and removed from the view in takeLeftSwipeRecognitionEnabledFrom:.
    Add the recognizer to the view if the segmented control shows that left swipe recognition is allowed.
    */
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeFrom:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setWords:(NSArray *)words
{
    [words retain];
    [_words release];
    _words = words;
    
    countOfKnow = 0;
}

@end
