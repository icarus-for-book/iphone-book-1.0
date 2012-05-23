#import "AddAccountViewController.h"

#import "GDataServiceGooglePhotos.h"

@interface AddAccountViewController()
// private method
- (GDataServiceGooglePhotos *)googlePhotosServiceWithId:(NSString*)username password:(NSString*)password;
- (void)ticket:(GDataServiceTicket *)ticket authenticatedWithError:(NSError *)error;
- (BOOL)isAlreadyLoginedUser:(NSString*) username;

- (void) onClickCancel:(id)sender;
- (void) onClickLogin:(id)sender;
// user interface를 사용하지 말지를 선택. login중에 사용자 입력을 받지 않기 위해서 사용.
- (void) enableUserInteraction:(BOOL)flag;

@end

@implementation AddAccountViewController

@synthesize loadingView = _loadingView;
@synthesize managedContext = _managedContext;
@synthesize username = _username;
@synthesize password = _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [_loadingView release];
    [_managedContext release];
    [_username release];
    [_password release];
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
    self.navigationItem.title = @"Add Account";
    
    // 네비게이션바에 두개의 버튼를 추가한다.
    // 취소 버튼과 로그인 버튼.
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onClickCancel:)];
    UIBarButtonItem *buttonLogin = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickLogin:)];
    
    self.navigationItem.rightBarButtonItem = buttonLogin;
    self.navigationItem.leftBarButtonItem = buttonCancel;
    
    [buttonCancel release];
    [buttonLogin release];
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

#pragma mark - 
#pragma mark event handler

// create google account
- (IBAction) clickCreateAccount:(id)sender
{
    NSURL *urlOfCreatingAccount = [NSURL URLWithString:@"https://www.google.com/accounts/NewAccount"];
    [[UIApplication sharedApplication] openURL:urlOfCreatingAccount];
}

// 기존에 같은 아이디로 등록되었는지 확인.
- (BOOL)isAlreadyLoginedUser:(NSString*) username
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"AccountInfo" inManagedObjectContext:self.managedContext];
    fetchRequest.entity = ent;
    [fetchRequest setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid = %@", username];
    [fetchRequest setPredicate:predicate];
    
    
    // before adding the earthquake, first check if there's a duplicate in the backing store
    NSError *error = nil;
    NSArray *fetchedItems = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    
    [fetchRequest release];
    return fetchedItems.count != 0;
}

#pragma mark - 
#pragma mark private method

// 구글 아이디와 암호로 계정을 확인하다. 계정 확인은 비동기로 이루어지고 
// 결과는 ticket:authenticatedWithError: 로 받을 것이다.
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

// 구글 서버로부터 로그인 계정확인에 대한 결과를 받는다. 
- (void)ticket:(GDataServiceTicket *)ticket authenticatedWithError:(NSError *)error
{
    if (error == nil) {
        // Login 성공이면 DB에 반영한다. 
        
        // Create a new instance of the entity managed by the fetched results controller.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountInfo" inManagedObjectContext:self.managedContext];
        AccountInfo *accountInfo = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedContext];
        
        accountInfo.userid = self.username.text;
        accountInfo.passwd = self.password.text;
        
        // Save the context.
        NSError *err = nil;
        if (![self.managedContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", err, [error userInfo]);
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }
    [self enableUserInteraction:YES];
    [self.loadingView removeView];
}    

// 취소를 한다면. 
- (void) onClickCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

// 로그인 버튼을 눈렸을때의 핸들러
// 로그인을 누르면 기존 계정인지 알아보가 
// 기존에 없는 계정이면 계정 정보를 확인한다. 
- (void) onClickLogin:(id)sender
{
    // check parameter
    if([self.username.text length] == 0) return;
    if([self.password.text length] == 0) return;
    
    if ([self.username.text rangeOfString:@"@"].location == NSNotFound) {
        self.username.text = [NSString stringWithFormat:@"%@@gmail.com",self.username.text];
    }
    
    // TODO 기존에 등록된 사용자와 같은 것이 있는지 확인
    if([self isAlreadyLoginedUser:self.username.text])
    {
        // 기존에 등록이 되어있으면 Account List로 이동
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    // Login 시도.
    
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    
    self.loadingView = [LoadingView loadingViewInView:self.view];
    self.loadingView.textLabel.text = @"계정 확인";
    
    [self enableUserInteraction:NO];
    
    GDataServiceGooglePhotos *service = [self googlePhotosServiceWithId:self.username.text password:self.password.text];

    [service authenticateWithDelegate:self
              didAuthenticateSelector:@selector(ticket:authenticatedWithError:)];
}

// 로그인 중간에 취소를 할 수 없도록 
// 컨트롤들의 인터액션을 막거나 풀어준다.
- (void) enableUserInteraction:(BOOL)flag
{
    self.username.enabled = flag;
    self.password.enabled = flag;
    
    self.navigationItem.leftBarButtonItem.enabled = flag;
    self.navigationItem.rightBarButtonItem.enabled = flag;
}

@end
