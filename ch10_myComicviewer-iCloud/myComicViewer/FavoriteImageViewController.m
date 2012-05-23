//
//  FavoriteImageViewController.m
//  myComicViewer
//

#import "FavoriteImageViewController.h"

@implementation FavoriteImageViewController

@synthesize imageScrollView;
@synthesize document;
@synthesize activityIndicator;

- (void)dealloc
{
    [activityIndicator release];
    [imageScrollView release];
    [document release];
    [super dealloc];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicator startAnimating];

    [self.document openWithCompletionHandler:^(BOOL success) {
        [self.imageScrollView displayImage:document.image];
        [self.activityIndicator stopAnimating];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.activityIndicator stopAnimating];
    
    // 이미지 닫혔다면 이중으로 닫지 않는다.
    if((self.document.documentState & UIDocumentStateClosed) == 0)
    {
        [self.document closeWithCompletionHandler:^(BOOL success) {
            self.document = nil;
        }];
    }
}

@end
