//
//  InputViewController.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 7. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputViewController.h"


@implementation InputViewController

@synthesize textView = _textView;
@synthesize textField = _textField;
@synthesize datePicker = _datePicker;

@synthesize inputType = _inputType;
@synthesize currentValue = _currentValue;
@synthesize delegate = _delegate;
@synthesize userInfo = _userInfo;

- (id) initWithType:(InputViewType) type
{
    self = [super initWithNibName:@"InputViewController" bundle:nil];
    if(self)
    {
        self.inputType = type;
    }
    return self;
}


- (void)dealloc
{
    [_userInfo release];
    [_textView release];
    [_textField release];
    [_datePicker release];
    [_currentValue release];
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
    [self relayoutController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self notifyChangeEvent];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) relayoutController
{
    [self.textField setHidden:YES];
    [self.textView setHidden:YES];
    [self.datePicker setHidden:YES];

    if(self.inputType == kInputViewTypeTextField)
    {
        [self.textField setHidden:NO];
        self.textField.text = self.currentValue;
        [self.textField becomeFirstResponder];
    } else if(self.inputType == kInputViewTypeDatePicker)
    {
        [self.datePicker setHidden:NO];
        self.datePicker.date = self.currentValue;
        
    } else if(self.inputType == kInputViewTypeTextView)
    {
        [self.textView setHidden:NO];
        self.textView.text = self.currentValue;
        [self.textView becomeFirstResponder];
    }
}
- (void) notifyChangeEvent
{
    if (self.inputType == kInputViewTypeTextView) {
        NSString *curValue = self.currentValue;
        
        if (! [curValue isEqualToString:self.textView.text]) {
            if(self.delegate)
            {
                [self.delegate inputViewController:self changedValue:self.textView.text ofType:self.inputType userInfo:self.userInfo];
            }
        }        
    } else if (self.inputType == kInputViewTypeTextField) {
        NSString *curValue = self.currentValue;
        
        if (! [curValue isEqualToString:self.textField.text]) {
            if(self.delegate)
            {
                [self.delegate inputViewController:self changedValue:self.textField.text ofType:self.inputType userInfo:self.userInfo];
            }
        }
    } else if (self.inputType == kInputViewTypeDatePicker) {
        NSDate *curValue = self.currentValue;
        
        if (! [curValue isEqualToDate:self.datePicker.date]) {
            if(self.delegate)
            {
                [self.delegate inputViewController:self changedValue:self.datePicker.date ofType:self.inputType userInfo:self.userInfo];
            }
        }
    }
}

@end
