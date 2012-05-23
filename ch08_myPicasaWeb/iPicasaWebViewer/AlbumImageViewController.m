//
//  AlbumImageViewController.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlbumImageViewController.h"
#import "AlbumImageCellView.h"
#import "RepositoryManager.h"
#import "ImageViewController.h"
#import "AlbumDetailViewController.h"

#define kTableCellHeight 107.0f;

#pragma mark -
#pragma mark GroupingPhotos

@interface GroupingPhotos : NSObject {
@private

    AlbumInfo *_albumInfo;
    NSInteger _groupSize;
    NSArray *_photos;
}

@property(nonatomic,retain) AlbumInfo *albumInfo;
@property(nonatomic,retain) NSArray *photos;
@property(nonatomic,assign) NSInteger groupSize;

- (NSInteger) numberOfGroups;
- (NSArray*)  itemsOfAtGroup:(NSInteger)groupIndex;

@end

@implementation GroupingPhotos

@synthesize photos = _photos;
@synthesize albumInfo = _albumInfo;
@synthesize groupSize = _groupSize;

- (void)dealloc
{
    [_albumInfo release];
    [super dealloc];
}

- (NSInteger) numberOfGroups
{
    NSInteger ret = ([_albumInfo.photos count] + self.groupSize - 1) / self.groupSize;
    
    NSLog(@"number of groups = %d", ret);
    
    self.photos = [_albumInfo.photos allObjects];
    
    return ret;
}

- (NSArray*)  itemsOfAtGroup:(NSInteger)groupIndex
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:self.groupSize];
    
    NSInteger startRow = groupIndex * _groupSize;
    NSInteger endRow = startRow + _groupSize;
    endRow = MIN( endRow, [_albumInfo.photos count] );
    
    for(NSInteger row=startRow ; row < endRow; row++)
    {
        NSLog(@"items 1 = %d",row);
        [ret addObject:[self.photos objectAtIndex:row]];
    }
    
    return ret;
}

@end

@interface AlbumImageViewController()
- (void)configureCell:(AlbumImageCellView*)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)fetchAllPhotos;
- (void)photosFetchTicket:(GDataServiceTicket *)ticket
        finishedWithFeed:(GDataFeedPhotoAlbum *)feed
                   error:(NSError *)error;
- (void)fetchURLString:(NSString *)urlString
          forPhotoView:(AlbumImageCellView *)view
                 userInfo:(void *)userInfo;
- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error;
- (PhotoInfo*) findOrCreatePhotoInfo:(NSString*)photoid;
- (void)updateChangePhotoList;

// pull-to-reload UI에서 리로드 상태를 변경하는 메소드
- (void) showReloadAnimationAnimated:(BOOL)animated;
// pull-to-reload를 통해서 데이블 뷰 갱신이 필요할때 호출됨
- (void) reloadTableViewDataSource;
// pull-to-reload를 통해서 데이터 갱신이 완료되었을때
- (void)dataSourceDidFinishLoadingNewData;


// handler for click detail button
- (void)clickShowDetail:(id)sender;
@end


@implementation AlbumImageViewController

@synthesize albumInfo=_albumInfo;
@synthesize googlePhotoService=_googlePhotoService;
@synthesize managedObjectContext=_managedObjectContext;

@synthesize photoFetchTicket=_photoFetchTicket;
@synthesize photoFetchError=_photoFetchError;
@synthesize photoFeed=_photoFeed;
@synthesize groupingPhotos = _groupingPhotos;

@synthesize tableCell=_tableCell;

AlbumImageCellView *_tableCell;

- (void)dealloc
{
    [refreshHeaderView release];
    [_groupingPhotos release];
    [_tableCell release];
    [_albumInfo release];
    [_googlePhotoService release];
    [_managedObjectContext release];
    [_photoFetchError release];
    [_photoFetchTicket release];
    [_photoFeed release];
      
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// 화면이 로드될때의 호출되는 메소드.
// 화면 구성이나 설정을 하는 로직들이 이곳에서 실행된다.
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"num photos in db = %d, num photos in server = %d", self.albumInfo.photos.count,[self.albumInfo.numOfPhotos intValue]);

    // 앨범에 기록된 사진 갯수와 실제 사진 갯수간의 차이가 있을때 서버로 부터
    // 정보를 가져와서 갱신한다. 사진의 추가나 삭제가 이루어져서 갯수가 달라질 수 있기 때문.
    if( self.albumInfo.photos.count != [self.albumInfo.numOfPhotos intValue] )
    {
        [self fetchAllPhotos];
    }
    
    // 화면에 표시할 썸네일 사진들들 그룹핑 ( 3개의 사진을 하나의 그룹으로 )
    _groupingPhotos = [[GroupingPhotos alloc] init];
    _groupingPhotos.groupSize = 3;
    _groupingPhotos.albumInfo = self.albumInfo;
    
    // 앨벗 상세 정보 화면으로 가기 위한 버튼을 생성
    UIButton *showAlbumInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [showAlbumInfo addTarget:self action:@selector(clickShowDetail:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[[UIBarButtonItem alloc] initWithCustomView:showAlbumInfo]autorelease];

    
    // 네비게이션 바 설정 
    self.navigationItem.title = self.albumInfo.title;
    self.navigationItem.leftBarButtonItem.title = @"Albums";
    self.navigationItem.rightBarButtonItem = customItem;
    
    // 풀-리로드 화면 설정 
    refreshHeaderView = [[RefreshTableHeaderView alloc] initWithFrame:
                         CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                    320.0f, self.view.bounds.size.height)];
	[self.tableView addSubview:refreshHeaderView];
    
    [self showReloadAnimationAnimated:YES];
    [self reloadTableViewDataSource];

}

// 화면 전환되기 직전에 호출되는 메소드
// 앨범의 "Title"이 변경되었을때 화면에 바로 반영하기 위해서
// 이곳에서 Title 설정을 한다. 여기서 설정한 Title은 
// 네비게이션 컨트를러의 타이틀 영역에 표시된다.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.albumInfo.title;
}

// 기기의 오리엔테이션이 변경될때 화면 오리엔테이션도 변경할 수 있는 물어오는 메소드.
// 이 화면은 세로 화면만 허용된다.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Table view data source

// 테이블 뷰의 셀의 높이 설정 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

// 테이블에 표시할 셀의 숫자. 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRows = %d",[_groupingPhotos numberOfGroups]);
    return [_groupingPhotos numberOfGroups];
}

// 테이블에 표시할 셀 생성 및 설정.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSLog(@" cell row = %d", indexPath.row);
    
    // 화면에 표시할 셀 뷰를 셀뷰 풀에서 찾는다. 
    // 없으면 생성하게 된다.
    AlbumImageCellView *cell = (AlbumImageCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        // NIB 파일로 부터 로드해서 생성한다.
        // 생성된 셀은 tableCell 프로퍼티에 바인딩 되어 있다.
        NSBundle *mainBundle = [NSBundle mainBundle];
        [mainBundle loadNibNamed:@"AlbumImageCellView" owner:self options:nil];
        cell = self.tableCell;
        // tableCell 프로퍼티에 바인딩 된 값은 생성하기 위해서 사용했으므로 
        // 필요 없으니 nil로 설정
        self.tableCell = nil;
    }
    
    // 셀에 표시할 사진들을 설정한다.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(AlbumImageCellView *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // 한 셀에 표시할 사진들을 가져온다.
    // 여기서는 3개의 썸네일을 표시할 것이므로 3개의 PhotoInfo 객체가 들어 있다.
    NSArray* items = [self.groupingPhotos itemsOfAtGroup:indexPath.row];

    // 셀의 델리케이트로 자신(self)를 설정한다.
    // 썸네일을 클릭하면 이벤트를 받아서 처리할 있도록 
    cell.delegate = self;
    
    // 표시할 썸네일 갯수가 3개 이상이면
    // 쎌의 세번째 이미지뷰에 썸네일 표시
    if ([items count] >= 3) {
        // 표시할 객체를 가져온다.
        PhotoInfo *photo = [items objectAtIndex:2];
        NSURL *thumbnailURL = [NSURL URLWithString:photo.thumbnail];
        if ([thumbnailURL isFileURL]) {
            // 표시할 객체의 URL이 파일이면 이미 가지고 있는 이미지 이므로 
            // 파일을 로드후에 바로 표시한다.
            [cell.loadingIndicator3 stopAnimating];
            cell.image3.image = [UIImage imageWithContentsOfFile:[thumbnailURL path]];
        } else {
            // 표시할 객체가 인터넷 URL이면 파일을 우선 가져와야 하므로
            // 인디케이터를 표시하고 이미지를 가져오도록 한다.
            // 파일을 모두 가져오면 화면에 표시할 것이다.
            [cell.loadingIndicator3 startAnimating];
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          photo,@"photo",
                                          [NSNumber numberWithInteger:3], @"index",
                                          nil];
                [self fetchURLString:photo.thumbnail
                        forPhotoView:cell
                            userInfo:userInfo];
            }
        }
    }
    // 표시할 썸네일이 2개 이상이면
    // 두번째 이미지뷰에 표시한다. 자세한 과정은 
    // 위에서 설명한 것과 동일하다.
    if ([items count] >= 2) {
        PhotoInfo *photo = [items objectAtIndex:1];
        NSURL *thumbnailURL = [NSURL URLWithString:photo.thumbnail];
        if ([thumbnailURL isFileURL]) {
            [cell.loadingIndicator2 stopAnimating];
            cell.image2.image = [UIImage imageWithContentsOfFile:[thumbnailURL path]];
        } else {
            [cell.loadingIndicator2 startAnimating];
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          photo,@"photo",
                                          [NSNumber numberWithInteger:2], @"index",
                                          nil];
                [self fetchURLString:photo.thumbnail
                        forPhotoView:cell
                            userInfo:userInfo];
            }
        }
    }
    // 표시할 썸네일이 1개 이상이면
    // 첫번째 이미지뷰에 표시한다. 자세한 과정은 
    // 위에서 설명한 것과 동일하다.
    if ([items count] >= 1) {
        PhotoInfo *photo = [items objectAtIndex:0];
        NSURL *thumbnailURL = [NSURL URLWithString:photo.thumbnail];
        if ([thumbnailURL isFileURL]) {
            [cell.loadingIndicator1 stopAnimating];
            cell.image1.image = [UIImage imageWithContentsOfFile:[thumbnailURL path]];
        } else {
            [cell.loadingIndicator1 startAnimating];
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          photo,@"photo",
                                          [NSNumber numberWithInteger:1], @"index",
                                          nil];
                [self fetchURLString:photo.thumbnail
                        forPhotoView:cell
                            userInfo:userInfo];
            }
        }
    }
    
}

#pragma private method

#pragma mark Fetch all albums

// 앨범의 사진 정보들을 가져오는 메소드
- (void)fetchAllPhotos {
    GDataServiceTicket *ticket;
    
    // 앨범의 사진을 가져오기 위한 query URL를 만든다.
    NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:self.albumInfo.account.userid
                                                             albumID:self.albumInfo.albumid
                                                           albumName:nil
                                                             photoID:nil
                                                                kind:nil
                                                              access:nil];
    // 피카사 서버로 데이터를 요청한다. 
    // 요청한 데이터를 받으면 photosFetchTicket:finishedWithFeed:error: 이 호출된다.
    ticket = [self.googlePhotoService fetchFeedWithURL:feedURL
                                              delegate:self
                                     didFinishSelector:@selector(photosFetchTicket:finishedWithFeed:error:)];
    [self setPhotoFetchTicket:ticket];
}

// fetchAllPhotos 메소드에서 요청한 응답을 받으면 호출되는 콜백 메소드
- (void)photosFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedPhotoAlbum *)feed
                       error:(NSError *)error {
    
    assert([NSThread isMainThread]);
    [self setPhotoFeed:feed];
    [self setPhotoFetchError:error];
    [self setPhotoFetchTicket:nil];
    
    if (error == nil) {
        // 에러가 없다면 앨범의 사진 정보들을 갱신한다.
        [self updateChangePhotoList];
    }

    // 데이터가 변경되었으므로 화면을 갱신한다.
    [self.tableView reloadData];
}

// 주어진 아이디에 대해서 코어 데이터에서 객체를 찾거나 없으면 
// 객체를 하나 생성해서 반환한다.
- (PhotoInfo*) findOrCreatePhotoInfo:(NSString*)photoid
{
    // 코어데이터에 주어진 아이디를 조회해본다.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoInfo"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoid == %@", photoid];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    PhotoInfo *photo = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // 조회한 정보가 없다면 PhotoInfo 객체를 하나 생성한다.
    // 물론 생성을 할때는 코어데이터를 사용해서 생성은 한다.
    
    if (fetchedObjects == nil) {
        // 조회자체가 실패 했을때.
        // 조회결과가 없어도 nil이 나오지는 않는다.
        NSLog(@"Cannot Fetch item in %s", __FUNCTION__);
        
    } else {
        // 조회 결과가 없으니 객체를 하나 생성한다. 
        if ([fetchedObjects count] > 0) {
            photo = [fetchedObjects objectAtIndex:0];
        } else {
            // Create a new instance of the entity managed by the fetched results controller.
            photo = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
            photo.album = self.albumInfo;
            
        }
    }
    
    [fetchRequest release];

    return photo;    
    
}

// 앨범정보를 서버에서 받은 데이터를 사용해서 데이터를 갱신하다.
- (void)updateChangePhotoList {
    
    // 갱신할 서버 데이터는 photoFeed 프로퍼티에 있다.
    GDataFeedPhotoAlbum *feed = [self photoFeed];
    // 앨범 정보중에서 사진들의 정보를 가져온다.
    // 앨범 Feed를 조회하면 사진 Entry를 없을 수 있다.
    NSArray *entries = [feed entries];
    
    // 사진 정보들을 갱신한다. 
    for (GDataEntryPhoto *photoEntry in entries )
    {
        NSString *photoid = [photoEntry GPhotoID];
        NSDate *updatedDate = [[photoEntry updatedDate] date];
        
        // 코어 데이터에 이미 ID에 해당하는 갱체가 있으면 정보를 갱신하고
        // 없으면 새로운 객체를 만들어서 추가한다. 
        PhotoInfo *photo = [self findOrCreatePhotoInfo:photoid];
        if ([photo.updated isEqualToDate:updatedDate]) {
            continue;
        }
        
        // 제목
        photo.title = [[photoEntry title] stringValue];
        // 앨범의 사진들의 날짜 ( 대표 날짜 )
        photo.updated = updatedDate;
        // 요약 정보
        photo.summary = [[photoEntry summary] stringValue];
        // 사진 아이디
        photo.photoid = photoid;
        // 사진 정보를 더 자세히 할 수 있는 URL
        photo.photo = [[[photoEntry selfLink] URL] absoluteString];
        
        // 썸 네일 정보 
        NSArray *thumbnails = [[photoEntry mediaGroup] mediaThumbnails];
        if ([thumbnails count] > 0) {
            photo.thumbnail = [[thumbnails objectAtIndex:0] URLString];
        }
        
        // 사진 가로 크기
        photo.width = [photoEntry width];
        // 사진 세로 크기
        photo.height = [photoEntry height];
        // 사진 파일 사이즈 
        photo.fileSize = [photoEntry size];
        
        // EXIF 정보
        GDataEXIFTags* exif = [photoEntry EXIFTags];
        if(exif != nil)
        {
            photo.camera = [exif valueForTagName:@"make"];
            photo.model = [exif valueForTagName:@"model"];
            photo.iso = [exif valueForTagName:@"iso"];
            photo.exposure = [exif valueForTagName:@"exposure"];
            photo.aperture = [exif valueForTagName:@"fstop"];
            photo.focalLength = [exif valueForTagName:@"focallength"];
            photo.flashUsed = [NSNumber numberWithBool: [[exif valueForTagName:@"flash"] boolValue]];
            photo.latitude = [exif valueForTagName:@"latitude"];
            photo.longitude = [exif valueForTagName:@"longitude"];
            
            // exif의 time이 localtime이기 때문에 GMT로 변환해서 NSDate를 만든다.
            NSTimeInterval timeOfShot = [[exif valueForTagName:@"time"] doubleValue] / 1000.0f;
            NSTimeZone *currentZone = [NSTimeZone systemTimeZone];
            timeOfShot -= [currentZone secondsFromGMT];
            photo.originalTime = [NSDate dateWithTimeIntervalSince1970:timeOfShot];

        }
    }
    
    // 데이터 갱신이 끝났으면 코어 데이터 정보들을 저장한다.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
}


// 썸네일 정보 갱신.
// 현재 보여지는 셀에 표시할 썸네일 정보를 다운 받기 시작한다.
- (void)loadImagesForOnscreenRows
{
    // 테이틀뷰에서 보이는 셀들을 구한다. 
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        // 표시할 셀에 표시할 사진 정보들을 구한다.
        NSArray* items = [self.groupingPhotos itemsOfAtGroup:indexPath.row];
        // 표시할 셀 객체
        AlbumImageCellView *cellView = (AlbumImageCellView *)[self.tableView cellForRowAtIndexPath: indexPath];
        
        NSInteger index = 0;
   
        // 사진 URL중에 파일 URL ( 이미 다운 받은 이미지 )이 아니면
        // 다운 로드를 시작한다.
        for(PhotoInfo *photo in items)
        {
            NSURL *thumbnailURL = [NSURL URLWithString:photo.thumbnail];
            if(![thumbnailURL isFileURL])
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          photo,@"photo",
                                          [NSNumber numberWithInteger:index + 1], @"index",
                                          nil];
                [self fetchURLString:photo.thumbnail
                        forPhotoView:cellView
                               userInfo:userInfo];
                    
            }
            index++;
        }
    }
    
}

// 썸네일 이미지를 다운 받기 시작한다.
- (void)fetchURLString:(NSString *)urlString
          forPhotoView:(AlbumImageCellView *)view
                 userInfo:(void *)userInfo {
    
    // HTTP프로토콜로 다운 받기 위한 Fetcher 객체를 구한다.
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:urlString];

    // userInfo에 view 객체를 추가한다.
    // 이 객체는 다운로드가 완료되었을 때 콜백메소드에서 사용할 것이다.
    NSMutableDictionary *modUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [modUserInfo setValue:view forKey:@"view"];
    [fetcher setUserData:modUserInfo];
    
    // 다운로드를 시작한다.
    // 완료가 되면 imageFetcher:finishedWithData:error: 가 호출될 것이다.
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
}

// 썸네일 이미지의 다운로드가 완료되었을때 호출되는 콜백 메소드
- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error {
    
    // 에러 없이 완료를 하였다면.
    if (error == nil) {
        // 이미지 데이터를 가지고 이미지 객체를 만든다. 
        UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
        
        // 사용자 데이터에서 필요한 데이터를 가져온다. 
        // 이 데이터덜을 다운로드를 시작할때 설정했던 객체들이다.
        NSDictionary *userInfo = [fetcher userData];
        // 표시할 셀
        AlbumImageCellView *cell = [userInfo objectForKey:@"view"];
        // 표시할 셀에서 표시할 이미지뷰의 인덱스
        NSInteger index = [[userInfo objectForKey:@"index"] intValue];
        // 표시할 PhotoInfo 객체
        // 다운로드가 완료되었으니 PhotoInfo 객체에 썸네일 URL을 수정해야 하기 때문에 필요.
        PhotoInfo *photo = [userInfo objectForKey:@"photo"];
        
        // 썸네일 이미지를 스토리지에 저장한다.
        // RepositoryManager는 썸네일 이미지를 저장, 삭제 하기 쉽도록 도와주는
        // HelpClass이다.
        RepositoryManager *repository = [[RepositoryManager alloc] initWithTags:[NSArray arrayWithObjects: 
                                                                                 photo.album.account.userid,
                                                                                 photo.album.albumid, nil]];
        
        NSString *savedPath = [repository writeData:data asName:photo.photoid];
        [repository release];
        
        // 스토리지에 저장 URL을 photoinfo 객체에 설정한다.
        photo.thumbnail = [[NSURL fileURLWithPath:savedPath] absoluteString];

        // 다운로드 받은 이미지를 화면에 표시한다.
        UIImageView *view = nil;
        switch (index) {
            case 1:
                view = cell.image1;
                [cell.loadingIndicator1 stopAnimating];
                break;
            case 2:
                view = cell.image2;
                [cell.loadingIndicator2 stopAnimating];
                break;
            case 3:
                view = cell.image3;
                [cell.loadingIndicator3 stopAnimating];
                break;
        }
        
        [view setImage:image];
    } else {
        // TODO 에러로 다운로드 받지 못한 것을 이미지로 표시 할것.
        NSLog(@"imageFetcher:%@ error:%@", fetcher,  error);
    }
}

#pragma mark -
#pragma mark handler for event

// 앨범 상세 정보를 클릭했을때 호출되는 콜백 메시지
- (void)clickShowDetail:(id)sender
{
    // 앨범 상세 정보 화면을 생성해서 화면에 표시한다.
    AlbumDetailViewController *viewController = [[AlbumDetailViewController alloc] initWithStyle: UITableViewStyleGrouped];
    viewController.album = self.albumInfo;
    viewController.googlePhotoService = self.googlePhotoService;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark -
#pragma mark 이미지 지연 로딩을 위한 UIScrollViewDelegate 구현 내용 

// 스크롤이 드레그가 끝났을때 호출되는 메소드로 
// 스코롤이 끝났을때 다운로드 받지 않은 이미지를 로드한다.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 스크롤이 엄추었을때 이미지 로드
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

// 스크롤이 끝났을때 호출되는 메소드
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark AlbumImageCellViewDelegate Handler

// 썸네일을 클릭했을때 호출되는 메소드로.
// 썸네일이 클릭되면 해당 이미지를 크게 보여주는 화면으로 
// 전환한단.
- (void)albumImageCell:(AlbumImageCellView*)cellView didClicked:(NSInteger) index
{
    // 클릭한 셀에 해당한는 사진 데이터(PhotoInfo객체)를 구한다.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellView];
    NSArray* items = [self.groupingPhotos itemsOfAtGroup:indexPath.row];
    PhotoInfo *photo = [items objectAtIndex: index -1 ];

    // 이미지 뷰어 화면을 생성해서 전환한다.
    ImageViewController *viewController = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    
    viewController.photos = self.groupingPhotos.photos;
    viewController.currentPhoto = photo;
    viewController.googlePhotoService = self.googlePhotoService;
    viewController.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark State Changes

// 리로딩 에니메이션을 표시하거나 숨긴다.
// 화면 상단에 표시된다.
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

// pull-to-reload를 통해서 데이블 뷰 갱신이 필요할때 호출됨
- (void) reloadTableViewDataSource
{
	//[self fetchAllAlbums];
    [self dataSourceDidFinishLoadingNewData];
}

// pull-to-reload를 통해서 데이터 갱신이 완료되었을때
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

// 스크롤이 시작할때 호출되는 메소드로 스크롤이 시작할때
// pull-to-reload를 검사할지 결정한다.
// 이미지 리로딩 중이 아니라면 스크롤을 멈쳤을때 pull-to-reload를 
// 검사한다.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (!reloading)
	{
		checkForRefresh = YES;  //  only check offset when dragging
	}
}

// 화면 스크롤이 끝났을때 호출되는 함수로 여기서 pull-to-reload를 검사해서
// 현재의 pull-to-reload상태를 변경한다.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 이미 리로딩 중이라면 무시
	if (reloading) return;
    
	if (checkForRefresh) {
		if (refreshHeaderView.isFlipped
            && scrollView.contentOffset.y > -65.0f
            && scrollView.contentOffset.y < 0.0f
            && !reloading) {
            // 당기면 리로드가 될거라는 메시지 표시
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kPullToReloadStatus];
            
		} else if (!refreshHeaderView.isFlipped
                   && scrollView.contentOffset.y < -65.0f) {
            // 여기서 드레그를 끝내면 리로드 상태가 될꺼라는 표시
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kReleaseToReloadStatus];
		}
	}
}


@end
