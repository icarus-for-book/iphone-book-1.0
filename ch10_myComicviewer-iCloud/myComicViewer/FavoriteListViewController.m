//
//  FavoriteListViewController.m
//  myComicViewer
//

#import "FavoriteListViewController.h"
#import "FavoriteDocument.h"
#import "FavoriteImageViewController.h"

@interface FavoriteListViewController ()

// 클라우드 파일 조회
// 조회가 완료되면 processFiles: 가 호출된다.
- (void)setupAndStartQuery;

// setupAndStartQuery에 의해서 시작된 클라우드 조회가
// 완료되었을때 호출됨
- (void)metaQueryDidFinishingGathering:(NSNotification*)aNotification;

@end

@implementation FavoriteListViewController

// 초기화 메소스
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // 찜한 아이템들 저장한 변수 초기화 
        favoriteItems = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

// 종료 메소스
- (void)dealloc
{
    // NSMeataQuery 중지
    if(query!=nil){
        [query stopQuery];
        [query release];
    }
    
    [favoriteItems release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"찜한 것 보기";

    // 닫기 버튼 추가
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    [closeButton release];

    
    // iCloud의 컨테이너를 검색 
    [self setupAndStartQuery];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 화면에 표시할 아이템은 favoriteItems 있는 것이다.
    return [favoriteItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // 쎌 설정
    FavoriteDocument *item = [favoriteItems objectAtIndex:indexPath.row];
    if(item.image != nil) {
        cell.imageView.image = item.image;
        cell.textLabel.text = item.localizedName;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"favorite.png"];
        cell.textLabel.text = @"Loading...";
        
        [item openWithCompletionHandler:^(BOOL success) {
            // 사진을 얻어오면 화면 갱신
            cell.imageView.image = item.image;
            cell.textLabel.text = item.localizedName;
            
            // 사진을 얻어온 후에 객체를 닫는다.
            if(success)
                [item closeWithCompletionHandler:nil];
        }];
        
    }
    
    
    return cell;
}

// 삭제를 지원하기 위해서
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView 
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 아이팀 삭제가 수행되었을때 
        
        // 선택된 아이템을 얻어 온다.
        FavoriteDocument *favoriteItem = [favoriteItems objectAtIndex:[indexPath row]];
        
        // NSFileCoordinator을 이용해서 파일을 삭제한다.
        // NSfileCoordinator는 주어진 경로의 파일을 삭제할 수 있을때 까지 
        // 삭제 명령을 유보시키고 있다가 다른 쓰레드에서 파일을 읽거나 쓰지 않는 것이 
        // 보장되면 삭제 명령을 수행할 수 있도록 보장한다.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // NSFileCoordinator 객체 생성
            NSFileCoordinator *fc = [[NSFileCoordinator alloc]
                                     initWithFilePresenter:nil];
            
            // 삭제 명령 수행.
            [fc coordinateWritingItemAtURL:favoriteItem.fileURL
                                   options:NSFileCoordinatorWritingForDeleting
                                     error:nil
                                byAccessor:^(NSURL *newURL) 
            {
                // NSFileManager를 사용해서 제거한다.
                // 제거방법은 기존의 파일 제거방식과 동일하다. 
                NSFileManager *fm = [[NSFileManager alloc] init];
                [fm removeItemAtURL:newURL error:nil];
            }];
        });

        // 삭제된 파일을 리스트에서도 제거한다.
        [favoriteItems removeObjectAtIndex:[indexPath row]];

        // 테이블 UI 갱신
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteImageViewController *viewController = [[FavoriteImageViewController alloc] initWithNibName:@"FavoriteImageViewController" bundle:nil];

    FavoriteDocument *selectedDoc = [favoriteItems objectAtIndex:indexPath.row];

    // 새로운 객체를 하나 생성한다. 
    // 문서 객체는 open & close가 각각 쌍으로 이루어져야 한다. 같은 객체를 사용할 경우
    // open & close 쌍이 깨질 수 있기 때문에 따로 생성한다.
    FavoriteDocument *doc = [[FavoriteDocument alloc] initWithFileURL:selectedDoc.fileURL];
    viewController.document = doc;
    [doc release];

    // 화면 전환 
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// 조회 Query 생성 
- (NSMetadataQuery*)createDocumentQuery {
    NSMetadataQuery* aQuery = [[NSMetadataQuery alloc] init];
    if (aQuery) {
        // 클라우드 컨테이너의 Documents 폴더만 검색
        [aQuery setSearchScopes:[NSArray
                                 arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        
        // 모든 파일을 검색한다.
        NSString* filePattern = [NSString stringWithFormat:@"*.*"];
        [aQuery setPredicate:[NSPredicate predicateWithFormat:@"%K LIKE %@",
                              NSMetadataItemFSNameKey, filePattern]];
    }
    
    return [aQuery autorelease];
}

- (void)setupAndStartQuery {
    // 조회를 위한 객체 생성
    if (!query)
        query = [[self createDocumentQuery] retain];

    // iCloud 메타데이터 쿼리에 대한 노티피게이션 등록 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(metaQueryDidFinishingGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:nil];

    
    // 조회 시작
    [query startQuery];
}

// 클라우드 컨테이너 검색이 끝나면 호출되는 메소드
- (void)metaQueryDidFinishingGathering:(NSNotification*)aNotification {
    NSMutableArray *queryedItems = [[NSMutableArray alloc] initWithCapacity:10];
    
    [query disableUpdates];
    
    // 검색된 파일들.
    NSArray *queryResults = [query results];
    
    for (NSMetadataItem *item in queryResults) {

//        NSMetatdataItem에 있는 값들
//        NSLog(@"url = %@", [item valueForAttribute:NSMetadataItemURLKey]);
//        NSLog(@"displayname = %@", [item valueForAttribute:NSMetadataItemDisplayNameKey]);
//        NSLog(@"change = %@", [item valueForAttribute:NSMetadataItemFSContentChangeDateKey]);
//        NSLog(@"create = %@", [item valueForAttribute:NSMetadataItemFSCreationDateKey]);
//        NSLog(@"name = %@", [item valueForAttribute:NSMetadataItemFSNameKey]);
//        NSLog(@"size = %@", [item valueForAttribute:NSMetadataItemFSSizeKey]);
//        NSLog(@"isCloud = %@", [item valueForAttribute:NSMetadataItemIsUbiquitousKey]);
//        NSLog(@"path = %@", [item valueForAttribute:NSMetadataItemPathKey]);
//        NSLog(@"hasconflict = %@", [item valueForAttribute:NSMetadataUbiquitousItemHasUnresolvedConflictsKey]);
//        NSLog(@"downloaded = %@", [item valueForAttribute:NSMetadataUbiquitousItemIsDownloadedKey]);
//        NSLog(@"downloding = %@", [item valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey]);
//        NSLog(@"uploaded = %@", [item valueForAttribute:NSMetadataUbiquitousItemIsUploadedKey]);
//        NSLog(@"uploading = %@", [item valueForAttribute:NSMetadataUbiquitousItemIsUploadingKey]);
//        NSLog(@"downpercent = %@", [item valueForAttribute:NSMetadataUbiquitousItemPercentDownloadedKey]);
//        NSLog(@"uppercent = %@", [item valueForAttribute:NSMetadataUbiquitousItemPercentUploadedKey]);
        
        // 파일 경로 
        NSURL *itemURL = [item valueForAttribute:NSMetadataItemURLKey];
        
        // 기존 리스트에서 같은 파일 경로를 갖는 객체가 있는지 확인하다.
        BOOL found = NO;
        for (FavoriteDocument *item in favoriteItems) {
            if( [item.fileURL isEqual:itemURL] ){
                found = YES;
                [queryedItems addObject:item];
                break;
            }
        }
        if (found) continue;
        
        // 기존에 같은 아이템이 없다면 새로 만들기
        FavoriteDocument *itemDoc = [[FavoriteDocument alloc] initWithFileURL:itemURL];
        [queryedItems addObject:itemDoc];
        [itemDoc release];
    }
    
    // 업데이트된 정보가 변경 되었을때만 적용
    if( ! [favoriteItems isEqualToArray:queryedItems] ) {
        // Update the list of documents.
        [favoriteItems removeAllObjects];
        [favoriteItems addObjectsFromArray:queryedItems];
        [self.tableView reloadData];
    }
    
    [queryedItems release];

    // 검색을 위한 노티피케이션을 제거한다.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    // query 객체 제거 
    [query stopQuery];
    [query release];
    query = nil;
}

// "찜한것" 보기  UI 제거.
- (IBAction) close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
