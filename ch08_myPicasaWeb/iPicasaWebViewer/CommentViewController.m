//
//  CommentViewController.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import "AddCommentViewController.h"

@interface CommentViewController()

- (void) fetchComments;

- (void) showReloadAnimationAnimated:(BOOL)animated;

- (void) reloadTableViewDataSource;
// 데이터 갱신이 완료되었을때 호출되는 메소드
- (void)dataSourceDidFinishLoadingNewData;


@end

@implementation CommentViewController

@synthesize googlePhotoService=_googlePhotoService;
@synthesize photo=_photo;
@synthesize comments=_comments;

- (void)dealloc
{
    [refreshHeaderView release];
    [_comments release];
    [_photo release];
    [_googlePhotoService release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.comments = [[NSArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickDone:)]; 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(clickWrite:)]; 
    
    // add pull-to-refresh
    
    refreshHeaderView = [[RefreshTableHeaderView alloc] initWithFrame:
                         CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                    320.0f, self.view.bounds.size.height)];
	[self.tableView addSubview:refreshHeaderView];
    
    [self showReloadAnimationAnimated:YES];
    [self reloadTableViewDataSource];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString* comment = [self.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment;
    return cell;
}

#pragma mark -
#pragma mark private method

// 댓글을 조회한다.
- (void) fetchComments
{
    // 댓글 조회를 위한 Query URL알 만든다.
    GDataQueryGooglePhotos *query;
    NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:self.photo.album.account.userid
                                                             albumID:self.photo.album.albumid
                                                           albumName:nil
                                                             photoID:self.photo.photoid
                                                                kind:@"comment"
                                                              access:nil];

    query = [GDataQueryGooglePhotos photoQueryWithFeedURL:feedURL];
    
    // 댓글을 조회한다.
    // 댓글 조회가 완료되면 fetchEntryTicket:finishedWithEntry:error: 가 호출된다.
    GDataServiceTicket *ticket;
    ticket = [self.googlePhotoService fetchEntryWithURL:[query URL] 
                                               delegate:self 
                                      didFinishSelector:@selector(fetchEntryTicket:finishedWithEntry:error:)];
    
}

// 댓글 조회가 완료되면 호출되는 메소드 
- (void)fetchEntryTicket:(GDataServiceTicket *)ticket
       finishedWithEntry:(GDataFeedPhoto *)photoEntry
                   error:(NSError *)error
{
    if (error == nil && [[photoEntry commentCount] intValue] > 0) {
        
        // photoEntry의 댓글들을 self.comments에 기록한다.
        NSInteger countOfComment = [[photoEntry commentCount] intValue];
        NSMutableArray *commentStrings = [[NSMutableArray alloc] initWithCapacity:countOfComment];
        NSArray *comments = [photoEntry entries];
        
        for (GDataEntryPhotoComment *comment in comments)
        {
            NSLog(@"comment = %@",[[comment content] stringValue]);
            [commentStrings addObject:[[comment content] stringValue]];
        }
        self.comments = commentStrings;

        // 테이블 갱신
        [self.tableView reloadData];

    } else {
        NSLog(@"error raised");
    }        

    // 데이터 갱신이 완료.
    // pull-to-reload 상태를 갱신한다.
    [self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
#pragma mark event handler

// 댓글 보기 화면 종료
- (void) clickDone:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

// 댓글 쓰기 화면으로 전환 
- (void) clickWrite:(id)sender
{
    AddCommentViewController *viewController = [[AddCommentViewController alloc] initWithNibName:@"AddCommentViewController" bundle:nil];
    viewController.googlePhotoService = self.googlePhotoService;
    viewController.photo = self.photo;
    viewController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentModalViewController:nav animated:YES];
    [viewController release];
}

// 댓글 쓰기가 완료되면 호출되는 메소드
- (void) addCommentViewControllerDidUpdated:(AddCommentViewController*)commentView
{
    // 댓글을 서버로 투버 다시 불러 온다.
    [self showReloadAnimationAnimated:YES];
    [self reloadTableViewDataSource];
}



#pragma mark State Changes

- (void) showReloadAnimationAnimated:(BOOL)animated
{
	reloading = YES;
	[refreshHeaderView toggleActivityView:YES];
    
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
                                                       0.0f);
		[UIView commitAnimations];
	}
	else
	{
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
                                                       0.0f);
	}
}

- (void) reloadTableViewDataSource
{
	[self fetchComments];
}

- (void)dataSourceDidFinishLoadingNewData
{
	reloading = NO;
	[refreshHeaderView flipImageAnimated:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[refreshHeaderView setStatus:kPullToReloadStatus];
	[refreshHeaderView toggleActivityView:NO];
	[UIView commitAnimations];
}

#pragma mark Scrolling Overrides
// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // pull-to-refresh
    
    if (reloading) return;
    
	if (scrollView.contentOffset.y <= - 65.0f) {
		if([self.tableView.dataSource respondsToSelector:
            @selector(reloadTableViewDataSource)]){
			[self showReloadAnimationAnimated:YES];
			[self reloadTableViewDataSource];
		}
	}
	checkForRefresh = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (!reloading)
	{
		checkForRefresh = YES;  //  only check offset when dragging
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (reloading) return;
    
	if (checkForRefresh) {
		if (refreshHeaderView.isFlipped
            && scrollView.contentOffset.y > -65.0f
            && scrollView.contentOffset.y < 0.0f
            && !reloading) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kPullToReloadStatus];
            
		} else if (!refreshHeaderView.isFlipped
                   && scrollView.contentOffset.y < -65.0f) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kReleaseToReloadStatus];
		}
	}
}



@end
