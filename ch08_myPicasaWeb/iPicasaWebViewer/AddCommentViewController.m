//
//  AddCommentViewController.m
//  iPicasaWebViewer
//
//  Created by jinni on 11. 7. 1..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddCommentViewController.h"
#import "LoadingView.h"

@interface AddCommentViewController()

// user interaction을 하지 못하게 한다.
- (void) enableUserInteraction:(BOOL)flag;

@end


@implementation AddCommentViewController

@synthesize googlePhotoService=_googlePhotoService;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize photo=_photo;
@synthesize delegate = _delegate;

@synthesize textView=_textView;
@synthesize loadingView = _loadingView;

- (void)dealloc
{
    [_loadingView release];
    [_textView release];
    [_photo release];
    [_googlePhotoService release];
    [_managedObjectContext release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickCancel:)]; 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickDone:)]; 
}

#pragma mark -
#pragma mark event handler
- (void) clickCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)postToPhotoTicket:(GDataServiceTicket *)ticket
       finishedWithEntry:(GDataFeedPhoto *)photoEntry
                   error:(NSError *)error
{
    if (self.delegate) {
        [self.delegate addCommentViewControllerDidUpdated:self];
    }
    [self dismissModalViewControllerAnimated:YES];
    [self.loadingView removeView];
    
    // enable buttons
    [self enableUserInteraction:YES];

}

- (void) clickDone:(id)sender
{
    self.loadingView = [LoadingView loadingViewInView:self.view];
    self.loadingView.textLabel.text = @"Comment 올리기";

    NSURL *query = [GDataServiceGooglePhotos photoFeedURLForUserID:self.photo.album.account.userid
                                                             albumID:self.photo.album.albumid
                                                           albumName:nil
                                                             photoID:self.photo.photoid
                                                                kind:@"comment"
                                                              access:nil];
    
    GDataEntryPhotoComment *comment = [GDataEntryPhotoComment commentEntryWithString:self.textView.text];
    
    GDataServiceTicket *ticket;
    
    ticket = [self.googlePhotoService fetchEntryByInsertingEntry:comment
                                                      forFeedURL:query
                                                        delegate:self 
                                               didFinishSelector:@selector(postToPhotoTicket:finishedWithEntry:error:)];
    
    // disable buttons
    [self enableUserInteraction:NO];
    
}

- (void) enableUserInteraction:(BOOL)flag
{
    self.navigationItem.leftBarButtonItem.enabled = flag;
    self.navigationItem.rightBarButtonItem.enabled = flag;
}



@end
