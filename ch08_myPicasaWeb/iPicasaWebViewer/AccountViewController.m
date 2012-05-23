#import "AccountViewController.h"
#import "AddAccountViewController.h"
#import "AlbumListViewController.h"
#import "SettingViewController.h"
#import "RepositoryManager.h"

@interface AccountViewController ()

// 수정 버튼를 눌렸을때
- (void) clickEditAccount;
// 계정 추가 
- (void) clickAddAcount;
// google photo service 생성.
// 이 object로 picasa 관련 api를 호출한다.
- (GDataServiceGooglePhotos *)googlePhotosServiceWithId:(NSString*)username password:(NSString*)password;
// table cell 설정 
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation AccountViewController

@synthesize tableView = _tableView;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;

- (void)dealloc
{
    [_tableView release];
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}


#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 타이틀 값 설정.
    self.navigationItem.title = @"Accounts";
    
    // 네비게이션 바에 버튼 생성
    // 1. 편집 버튼 ( 계정 삭제를 위해서 )
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                    target:self 
                                    action:@selector(clickEditAccount)];
    
    self.navigationItem.leftBarButtonItem = editButton;
    [editButton release];
    
    // 2. 추가 버튼 ( 계정 추가를 우해서 )
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                  target:self 
                                  action:@selector(clickAddAcount)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark - 
#pragma mark UITableViewDataSource handler

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AccountInfo *accountInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = accountInfo.userid;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete repository
        AccountInfo *info = [self.fetchedResultsController objectAtIndexPath:indexPath];
        RepositoryManager *repository = [[RepositoryManager alloc] initWithTags:[NSArray arrayWithObject:info.userid]];
        [repository deleteRepository];
        
//        for(AlbumInfo* album in info.albums)
//        {
//            [self.managedObjectContext deleteObject:album];
//        }
//        [self.managedObjectContext save:NULL];
        
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:info];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }   
}

#pragma mark - 
#pragma mark UITableViewDelegate handler

// 선택한 계정의 앨범 list로 이동한다.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 주어진 계정의 앨범리스트 보여주기
    AccountInfo *accountInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    AlbumListViewController *viewController = [[AlbumListViewController alloc] init];
    
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.accountInfo = accountInfo;
    viewController.googlePhotoService = [self googlePhotosServiceWithId:accountInfo.userid password:accountInfo.passwd];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}



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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userid" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"AccountView"];
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
    [self.tableView beginUpdates];
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
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark event handler

// 편집 모드 변경.
- (void) clickEditAccount
{
    if(self.tableView.editing)
    {
        [self.tableView setEditing:NO];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                                                                               target:self 
                                                                                               action:@selector(clickEditAccount)] autorelease];
        
    } else {
        [self.tableView setEditing:YES];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self 
                                                                                               action:@selector(clickEditAccount)] autorelease];
    }
}
// 계정 추가
- (void) clickAddAcount
{
    AddAccountViewController *viewController = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];
    viewController.managedContext = self.managedObjectContext;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    //nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:nav animated:YES];
    
    [nav release];
    [viewController release];
}

// setting 버튼을 누르면 수행.
- (IBAction) clickSetting:(id)sender
{
    SettingViewController* viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:nav animated:YES];
    
    [nav release];
    [viewController release];
}

#pragma mark -
#pragma mark private method


- (GDataServiceGooglePhotos *)googlePhotosServiceWithId:(NSString*)username password:(NSString*)password
{
    
    static GDataServiceGooglePhotos* service = nil;
    
    if (!service) {
        service = [[GDataServiceGooglePhotos alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // update the username/password each time the service is requested
    if ([username length] && [password length]) {
        [service setUserCredentialsWithUsername:username
                                       password:password];
    } else {
        [service setUserCredentialsWithUsername:nil
                                       password:nil];
    }
    
    return service;
}




@end
