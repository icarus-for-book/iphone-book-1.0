//
//  AlbumListViewController.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "AlbumListViewController.h"
#import "AlbumListCellView.h"
#import "AlbumImageViewController.h"
#import "RepositoryManager.h"

// 각 셀의 높이 정의.
// 현재 Custom Cell을 사용하고 있으므로 Cell의 높이를 정의한다. 
static const CGFloat kTableCellHeight = 73.0f;

@interface AlbumListViewController ()
- (void)fetchAllAlbums;
- (void)albumListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedPhotoUser *)feed
                       error:(NSError *)error;
- (void)fetchURLString:(NSString *)urlString
          forAlbumView:(AlbumListCellView *)view
                 userInfo:(void *)info;
- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error;

- (void)updateChangeAlbumList;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

// update Thumnail Image 
- (void)loadImagesForOnscreenRows;

- (void) reloadTableViewDataSource;

@property(nonatomic, retain) GDataServiceTicket *albumFetchTicket;
@property(nonatomic, retain) NSError            *albumFetchError;
@property(nonatomic, retain) GDataFeedPhotoUser *albumFeed;
@end

@implementation AlbumListViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize accountInfo = _accountInfo;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize googlePhotoService = _googlePhotoService;
@synthesize tableCell = _tableCell;
@synthesize filteredArray = _filteredArray;
@synthesize searchIsActive = _searchIsActive;
@synthesize searchController = _searchController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_searchController release];
    [_filteredArray release];
    [_repositoryManager release];
    [_albumFeed release];
    [_albumFetchError release];
    [_albumFetchTicket release];
    [_accountInfo release];
    [_managedObjectContext release];
    [_googlePhotoService release];
    [__fetchedResultsController release];
    [refreshHeaderView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    refreshHeaderView = [[RefreshTableHeaderView alloc] initWithFrame:
                         CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                    320.0f, self.view.bounds.size.height)];
	[self.tableView addSubview:refreshHeaderView];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    if( [sectionInfo numberOfObjects] == 0)
    {
        
        [self showReloadAnimationAnimated:YES];
        [self reloadTableViewDataSource];
    
    }
    
    // create search bar
    UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f,0.0f, 320.0f, 44.0f)] autorelease];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.searchController = [[UISearchDisplayController alloc] 
                                                    initWithSearchBar:searchBar 
                                                   contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;


    self.tableView.tableHeaderView = searchBar;
    
    [searchBar release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.accountInfo.userid;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"num of section : %d", [[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( self.searchIsActive )
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
        
    } else 
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = indexPath.row % 2 == 0 ? @"Cell-Even" : @"Cell-Odd";
    
    AlbumListCellView *cell = nil;
    cell = (AlbumListCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        [mainBundle loadNibNamed:@"AlbumListCellView" owner:self options:nil];
        cell = self.tableCell;

        if(indexPath.row % 2 == 0){
            cell.backgroundView.backgroundColor = [UIColor lightGrayColor];
        } else {        
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
        }
        
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlbumInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account.userid like %@", self.accountInfo.userid];
    [fetchRequest setPredicate:predicate];
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"published" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}   

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([self searchIsActive]) {
        
        [[[self searchDisplayController] searchResultsTableView] beginUpdates];
    }
    else  {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([self searchIsActive]) {
        [[[self searchDisplayController] searchResultsTableView] endUpdates];
    }
    else  {
        [self.tableView endUpdates];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    AlbumImageViewController *viewController = [[AlbumImageViewController alloc] init];
    
    viewController.managedObjectContext = self.managedObjectContext;
 
    AlbumInfo *album = [self.fetchedResultsController objectAtIndexPath:indexPath];
    viewController.albumInfo = album;
    viewController.googlePhotoService = self.googlePhotoService;
    
    self.navigationItem.title = @"Albums";
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];

}

#pragma mark - 
#pragma mark private method
//- (void) clickAddAlbum:(id)sender
//{
//    SelectAlbumViewController *viewController = [[SelectAlbumViewController alloc] init];
//    
//    viewController.managedObjectContext = self.managedObjectContext;
//    
//    viewController.accountInfo = self.accountInfo;
//    viewController.googlePhotoService = self.googlePhotoService;
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//    [self presentModalViewController:nav animated:YES];
//    [nav release];
//    [viewController release];      
//}


@synthesize albumFetchTicket = _albumFetchTicket;
@synthesize albumFetchError = _albumFetchError;
@synthesize albumFeed = _albumFeed;

#pragma mark Fetch all albums

// begin retrieving the list of the user's albums
- (void)fetchAllAlbums {
    GDataServiceTicket *ticket;
    NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:self.accountInfo.userid
                                                             albumID:nil
                                                           albumName:nil
                                                             photoID:nil
                                                                kind:nil
                                                              access:nil];
    ticket = [self.googlePhotoService fetchFeedWithURL:feedURL
                              delegate:self
                     didFinishSelector:@selector(albumListFetchTicket:finishedWithFeed:error:)];
    [self setAlbumFetchTicket:ticket];
}


// album list fetch callback
- (void)albumListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedPhotoUser *)feed
                       error:(NSError *)error {
    [self setAlbumFeed:feed];
    [self setAlbumFetchError:error];
    [self setAlbumFetchTicket:nil];
    
    if (error == nil) {
        [self updateChangeAlbumList];
    }
    
    [self.tableView reloadData];
    [self dataSourceDidFinishLoadingNewData];

}

- (AlbumInfo*) findOrCreateAlbumInfo:(NSString*)photoid
{
    // find alread item in db
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlbumInfo"
    inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"albumid == %@", photoid];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    AlbumInfo *album = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
        NSLog(@"Cannot Fetch item in %s", __FUNCTION__);

    } else {
        
        if ([fetchedObjects count] > 0) {
            album = [fetchedObjects objectAtIndex:0];
        } else {
            // Create a new instance of the entity managed by the fetched results controller.
            album = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
            
        }
    }

    [fetchRequest release];
    return album;    
}

// update local db from server infomation.
- (void)updateChangeAlbumList {
    
    GDataFeedPhotoUser *feed = [self albumFeed];
    NSArray *entries = [feed entries];
    
    for (int idx = 0; idx < [entries count]; idx++) {
        GDataEntryPhotoAlbum *albumEntry = [entries objectAtIndex:idx];

        NSString *photoid = [albumEntry GPhotoID];
        NSDate *updatedDate = [[albumEntry updatedDate] date];

        AlbumInfo *album = [self findOrCreateAlbumInfo:photoid];
        if ([album.updated isEqualToDate:updatedDate]) {
            continue;
        }
        
        album.title = [[albumEntry title] stringValue];
        album.access = [albumEntry access];
        album.updated = updatedDate;
        album.published = [[albumEntry publishedDate] date];
        album.summary = [[albumEntry summary] stringValue];
        album.albumid = photoid;
        album.numOfPhotos = [albumEntry photosUsed];
        
        NSArray *thumbnails = [[albumEntry mediaGroup] mediaThumbnails];
        if ([thumbnails count] > 0) {
            album.thumbnail = [[thumbnails objectAtIndex:0] URLString];
        }
        album.account = self.accountInfo;
    }
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } 
}

- (void)configureCell:(AlbumListCellView *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AlbumInfo *album = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textTitle.text = album.title;
    cell.textSubtitle.text = [NSString stringWithFormat:@"%@ photos", album.numOfPhotos];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSLog(@"level = %@", album.access);
    if([album.access isEqualToString:@"private"])
    {
        cell.accessLevel = kAccessLevelPrivate;
    } else if([album.access isEqualToString:@"public"])
    {
        cell.accessLevel = kAccessLevelPublic;
        
    } else if([album.access isEqualToString:@"protected"])
    {
        cell.accessLevel = kAccessLevelProtected;
    }
    
    // make thumbnail round image
    cell.imageThumb.layer.masksToBounds = YES;
    cell.imageThumb.layer.cornerRadius = 5;
    cell.imageThumb.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.imageThumb.layer.borderWidth = 1.0; 
    
    NSURL *thumbnailURL = [NSURL URLWithString:album.thumbnail];
    
    if ([thumbnailURL isFileURL]) {
        [cell.loadingIndicator stopAnimating];
        
        cell.imageThumb.image = [UIImage imageWithContentsOfFile:[thumbnailURL path]];
        
    } else {
        [cell.loadingIndicator startAnimating];
        
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self fetchURLString:album.thumbnail
                    forAlbumView:cell
                        userInfo:album];
        }
    }

}



// update Thumnail Image 
- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        // thumbnail path 구하기
        AlbumInfo *album = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSURL *thumbnailURL = [NSURL URLWithString:album.thumbnail];
        if(![thumbnailURL isFileURL])
        {
            AlbumListCellView *cellView = (AlbumListCellView *)[self.tableView cellForRowAtIndexPath: indexPath];
            
            [self fetchURLString:album.thumbnail
                    forAlbumView:cellView
                           userInfo:album];
        }
        
    }

}

- (void)fetchURLString:(NSString *)urlString
          forAlbumView:(AlbumListCellView *)view
                 userInfo:(void *)info {
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:urlString];
    
    // use the fetcher's userData to remember which image view we'll display
    // this in once the fetch completes
    [fetcher setUserData:view];
    
    [fetcher setProperty:info forKey:@"album"];
    
    AlbumInfo *album = (AlbumInfo *)info;
    
    
    // http logs are more readable when fetchers have comments
    [fetcher setCommentWithFormat:@"thumbnail for %@", album.title];
    
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
}

- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error {
    if (error == nil) {
        // save data in local
        
        AlbumInfo *album = [fetcher propertyForKey:@"album"];
        RepositoryManager *repository = [[RepositoryManager alloc] initWithTags:[NSArray arrayWithObjects: 
                                                                                   album.account.userid,
                                                                                   album.albumid,
                                                                                @"thumbnail", nil]];
        
        NSString *savedPath = [repository writeData:data asName:@"album.png"];
        [repository release];
        
        album.thumbnail = [[NSURL fileURLWithPath:savedPath] absoluteString];
        
        // got the data; display it in the image view
        UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
        
        AlbumListCellView *cell = (AlbumListCellView *)[fetcher userData];
        [cell.loadingIndicator stopAnimating];
        cell.imageThumb.image = image;
    } else {
        NSLog(@"imageFetcher:%@ error:%@", fetcher,  error);
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
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
	[self fetchAllAlbums];
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

#pragma mark -
#pragma mark Content Filtering


// filter content for text that are you searching
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    // create a request 
    NSFetchRequest *aRequest = [[self fetchedResultsController] fetchRequest];
    
    /* it's important to say that a predicate is like a "WHERE" statment from SQL. It's used to filter the data fetched from store file. So here i used predicate with format beginwith (i use for a note app)*/
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH[cd] %@", searchText];
    
    // set predicate to the request 
    [aRequest setPredicate:predicate];
    
    // save changes
 
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }   
} 

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

// this method is used to reload tableView for string introduced in search bar
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:nil];
    return YES;
}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    // set searcIsActive to YES
    [self setSearchIsActive:YES];
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller 
{    
    [NSFetchedResultsController deleteCacheWithName:self.accountInfo.userid];

    // create a request
    NSFetchRequest *aRequest = [[self fetchedResultsController] fetchRequest];
    // and pass to it a nil predicate
    [aRequest setPredicate:nil];
    //save data
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }  
    // set searchIsActive to NO  (search ended)
    [self setSearchIsActive:NO];
    
    // itableView is an outlet to my tableview in rootviewcontroller 
    // refresh the data it's display
    [[[self searchDisplayController] searchResultsTableView] reloadData];
    
    return;
}


@end
