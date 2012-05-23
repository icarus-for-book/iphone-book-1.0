//
//  ImageViewController.m
//  iPicasaWebViewer
//
//  Created by jinni on 11. 6. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"
#import "RepositoryManager.h"
#import "CommentViewController.h"
#import "ImageScrollView.h"
#import "PhotoDetailViewController.h"

@interface ImageViewController()

// update title of image view
- (void) updateTitleOfCurrentImage;
// photo url 가져오기
- (void) fetchPhoto;
- (void)fetchEntryTicket:(GDataServiceTicket *)ticket
       finishedWithEntry:(GDataEntryPhoto *)photoEntry
                   error:(NSError *)error;

- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error;
// 현재 주어진 정보를 View에 표시 
- (void)updateCurrentData;

@end


@implementation ImageViewController

@synthesize photos=_photos;
@synthesize currentPhoto=_currentPhoto;
@synthesize imageView=_imageView;
@synthesize textTitle=_textTitle;
@synthesize loadingIndicator=_loadingIndicator;

@synthesize googlePhotoService=_googlePhotoService;
@synthesize managedObjectContext=_managedObjectContext;

@synthesize photoFetchTicket=_photoFetchTicket;
@synthesize photoFetchError=_photoFetchError;
@synthesize photoFeed=_photoFeed;

@synthesize buttonPrev = _buttonPrev;
@synthesize buttonNext = _buttonNext;
@synthesize buttonSlide = _buttonSlide;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_buttonSlide release];
    [_buttonPrev release];
    [_buttonNext release];
     
    [_googlePhotoService release];
    [_managedObjectContext release];
    [_photoFetchError release];
    [_photoFetchTicket release];
    [_photoFeed release];
    [_repository release];
    [_loadingIndicator release];
    [_textTitle release];
    [_imageView release];
    [_photos release];
    [_currentPhoto release];
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
    
    // i ( Info 버튼 ) 버튼을 넣게 위해서 UIButton 객체를 하나 만들고 UIBarButtonItem으로
    // 감싸서 네비게이션 버튼에 추가한다.
    UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [buttonInfo addTarget:self 
                   action:@selector(clickShowDetail:) 
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[[UIBarButtonItem alloc] initWithCustomView:buttonInfo]autorelease];

    // 네비게이션 버튼의 오른쪽에 추가한다.
    self.navigationItem.rightBarButtonItem = customItem;
    
    // 사진을 임시 저장할 때 임시저장된 파일을 관리하기 위한 
    // RepositoryManager를 생선한다. 
    _repository = [[RepositoryManager alloc] initWithTags:[NSArray arrayWithObjects: 
                                                          self.currentPhoto.album.account.userid,
                                                          self.currentPhoto.album.albumid, 
                                                           @"images", nil]];

}


- (void)updateCurrentData
{
    // 타이틀 정보를 갱신한다. ( ex. "1 of 17" )
    [self updateTitleOfCurrentImage];
    
    // load image 
    NSURL *photoURL = [NSURL URLWithString:self.currentPhoto.photo];
    
    if ([photoURL isFileURL]) {
        // 캐쉬에 있는 사진 데이터는 사진을 바로 표시한다.
        [self.loadingIndicator stopAnimating];
        [self.imageView displayImage:[UIImage imageWithContentsOfFile:[photoURL path]]];
    } else {
        // 캐쉬에 없는 사진이면 인디케이션을 활성화시키고
        // 사진을 가져온다. 
        // 사진을 다 가져오면 사진을 화면에 표시할 것이다.
        [self.loadingIndicator startAnimating];
        [self fetchPhoto];
    }
    
    // 사진에 부연 설명(Summary)가 있으면 화면에 표시한다.
    NSString *summary = self.currentPhoto.summary;
    if (summary == nil || [summary length] == 0) {
        self.textTitle.hidden = YES;
    } else {
        self.textTitle.hidden = NO;
        self.textTitle.text = self.currentPhoto.summary;
    }
    
    // 현재 표시하는 사진 정보가 앨범의 사진 목록중에 어떤 
    // 위치에 있는지 찾는다. ( curIndex )
    NSInteger curIndex = [self.photos indexOfObject:self.currentPhoto];
    self.buttonPrev.enabled = YES;
    self.buttonNext.enabled = YES;

    // 앨범에서 첫번째 사진이면 이번 사진으로 가는 
    // 컨트롤을 비활성화 시킨다.
    if (curIndex == 0) {
        self.buttonPrev.enabled = NO;
    }
    // 현재 사진이 앨범의 마지막 사진이면 다음 사진으로 가는 
    // 컨트롤을 비활성환 시킨다.
    if(curIndex >= self.photos.count - 1)
    {
        self.buttonNext.enabled = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// bar style변경
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCurrentData];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

// bar style을 이전의 style로 변경.
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark private method

- (void) updateTitleOfCurrentImage
{
    self.navigationItem.title = [NSString stringWithFormat:@"%d of %d", [self.photos indexOfObject:self.currentPhoto] + 1, self.photos.count];
}

// 구글 사진을 가져오면 호출되는 콜백 메소드
- (void)imageFetcher:(GTMHTTPFetcher *)fetcher 
    finishedWithData:(NSData *)data 
               error:(NSError *)error 
{
    if (error == nil) {
        // 서버로 부터 받은 이미지 데이터를 사용해서 화면 이미지를 갱신한다.
        UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
        [self.imageView displayImage:image];
        
        // 이미지 데이터를 캐쉬에 저장한다.
        // 여기서 저장한 정보를 다음번에 표시할때 사용될 것이다.
        NSString *savedPath = [_repository writeData:data asName:self.currentPhoto.photoid];
        
        // photo URL을 캐쉬의 URL로 변경한다.
        self.currentPhoto.photo = [[NSURL fileURLWithPath:savedPath] absoluteString];
        
        // 로딩 인디케이터 중지
        [self.loadingIndicator stopAnimating];
    } else {
        // 서버로부터 데이터를 가져오지 못했다면 에러출력
        // TODO 에러 발생시 에러를 나타내는 이미지를 표시하도록 해야 한다.
        NSLog(@"imageFetcher:%@ error:%@", fetcher,  error);
    }
}

// 현재 사진을 서버로부터 조회한다.
- (void) fetchPhoto
{
    // 조회할 Query를 만든다.
    // 조회에 사용될 FeedURL은 self.currentPhoto.photo 변수에 있다. 
    GDataQueryGooglePhotos *query;
    NSURL *photoURL = [NSURL URLWithString:self.currentPhoto.photo];
    query = [GDataQueryGooglePhotos photoQueryWithFeedURL:photoURL];
    
    // 최대 사이즈의 이미지를 조회한다.
    // 단말의 상황에 따라서 특정 크기보다 작은 이미지가 필요할 때가 있다 
    // 이때 사용되는 값이다. 참고 사이트에서 imgmax의 값을 찾아봐라.
    // ref : http://code.google.com/intl/ko-KR/apis/picasaweb/docs/2.0/reference.html
    //
    // 여기서 사용될 값은 설정 화면에서 설정한 이미지 사이즈를 설정할 것이다.
    Setting *setting = [Setting sharedSetting];
    NSInteger imageMaxSize = [setting imageMaxSize];
    [query setImageSize:imageMaxSize];
    
    // 구글 서버에서 이미지를 가져온다.
    // 완료되면 fetchEntryTicket:finishedWithEntry:error:가 호출됨
    GDataServiceTicket *ticket;
    ticket = [self.googlePhotoService fetchEntryWithURL:[query URL] 
                                               delegate:self 
                                      didFinishSelector:@selector(fetchEntryTicket:finishedWithEntry:error:)];

}

- (void)fetchEntryTicket:(GDataServiceTicket *)ticket
       finishedWithEntry:(GDataEntryPhoto *)photoEntry
                   error:(NSError *)error
{
    if (error == nil) {
        // 이미지를 제대로 가져왔다면 이미지를 가져올 수 있는 URL을 Entry의 mediaContents에 찾을 수 있다. 
        // 조금 복잡한 구조이지만 구글이 기존의 프로토콜을 사용하므로써 쓰기 딱 좋겠 만들지는 못했다.
        // 어쨌던 image 정보는 mediaGroup의 mediaContents에 들어 있다.
        // http://code.google.com/apis/picasaweb/docs/2.0/reference.html#media_content
        //
        // 최근에는 쓰기 불편한 사용법을 보안하기 위해서 XML이 아닌 JSON 방식으로 프로토콜을 옮기고 있는 
        // 추세이다. 
        // JSON방식의 Object-C라이브러니는 http://code.google.com/p/google-api-objectivec-client/ 를
        // 참조해라. 하지만 JSON 방식은 피카사에서 지원하지 않는다. 하지만 조만간 구글 지원 되지 않을까 
        // 생각한다. 그때는 지금보다 쉽게 개발을 할 수 있을 것이다.
        NSArray *mediaContents = [[photoEntry mediaGroup] mediaContents];
        GDataMediaContent *imageContent;
        imageContent = [GDataUtilities firstObjectFromArray:mediaContents
                                                  withValue:@"image"
                                                 forKeyPath:@"medium"];
        if (imageContent) {
            // meida group의 이미지 URL을 구한다.
            NSURL *downloadURL = [NSURL URLWithString:[imageContent URLString]];

            // 실제 이미지는 downloadURL로 다시 요청을 한다.
            NSMutableURLRequest *request = [self.googlePhotoService requestForURL:downloadURL
                                                             ETag:nil
                                                       httpMethod:nil];
            GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
            [fetcher setAuthorizer:[self.googlePhotoService authorizer]];
            
            // http logs are easier to read when fetchers have comments
            [fetcher setCommentWithFormat:@"downloading %@",
             [[photoEntry title] stringValue]];
           
            // 다운 로드를 시작한다. 완료가 되면 imageFetcher:finishedWithData:error: 이 호출된다.
            [fetcher beginFetchWithDelegate:self
                          didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
            
        } else {
            // no image content for this photo entry; this shouldn't happen for
            // photos
        }
    } else {
        NSLog(@"error raised");
    }        
}

#pragma mark -
#pragma mark event handler

// 이전 사진으로 이동
- (IBAction) clickShowPrev:(id)sender
{
    NSInteger curIndex = [self.photos indexOfObject:self.currentPhoto];
    curIndex--;
    self.currentPhoto = [self.photos objectAtIndex:curIndex];
    [self updateCurrentData];
}

// 다음 사진으로 이동
- (IBAction) clickShowNext:(id)sender
{
    NSInteger curIndex = [self.photos indexOfObject:self.currentPhoto];
    curIndex++;
    self.currentPhoto = [self.photos objectAtIndex:curIndex];
    [self updateCurrentData];
}

// 댓글 보기 화면으로 전환
- (IBAction) clickShowComment:(id)sender
{
    CommentViewController *viewController = [[CommentViewController alloc] init];
    viewController.googlePhotoService = self.googlePhotoService;
    viewController.photo = self.currentPhoto;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentModalViewController:nav animated:YES];
    [viewController release];
}

// 사진 메타 정보 보기 화면으로 전환
- (void)clickShowDetail:(id)sender
{
    PhotoDetailViewController *viewController = [[PhotoDetailViewController alloc] initWithStyle: UITableViewStyleGrouped];
    
    viewController.photo = self.currentPhoto;
    viewController.googlePhotoService = self.googlePhotoService;
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
}

@end
