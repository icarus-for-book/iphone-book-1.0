//
//  AlbumDetailViewController.m
//  iPicasaWebViewer
//
//  Created by jinni on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "OptionViewController.h"

// 앨범 상세 정보에 표시할 정보들.
enum {
    kAlbumItemTitle,        // 앨범명
    kAlbumItemDate,         // 앨범의 대표 날짜 
    kAlbumItemSummary,      // 앨범 요약
    kAlbumItemLocation,     // 앨범 사진들의 장소 ( 대표 장소 )
    kAlbumItemAccess,       // 접근 권한 
    kAlbumItemCount        
};

// 화면에 표시한 스트링

#define kAlbumItemTitleString       @"Title"
#define kAlbumItemDateString        @"Date"
#define kAlbumItemSummaryString     @"Summary"
#define kAlbumItemLocationString    @"Location"
#define kAlbumItemAccessString      @"Access"


// x가 nil이면 기본 값을 반한하는 매크로
#define OBJECT_VAL(x, obj)   (x == nil) ? obj : (x)


// 비공개 프로퍼티와 메소드
@interface AlbumDetailViewController()

@property(nonatomic, retain) NSMutableArray *tempData;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;

// 정보 서버에 반영
- (void) onSave:(id)sender;
   
@end


@implementation AlbumDetailViewController

@synthesize loadingView = _loadingView;
@synthesize album = _album;
@synthesize tempData = _tempData;
@synthesize dateFormatter = _dateFormatter;
@synthesize googlePhotoService = _googlePhotoService;

- (void)dealloc
{
    [_loadingView release];
    [_googlePhotoService release];
    [_dateFormatter release];
    [_tempData release];
    [_album release];
    [super dealloc];
}

#pragma mark - View lifecycle

// 화면이 로드될 때 호출되는 메소드
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 화면에 표시한 타이트명 표시
    // 이 값은 네비게이션바에 표시된다.
    self.navigationItem.title = self.album.title;
    
    // save 생성 후 네비게시션바 오른쪽에 추가 
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // 이 뷰에서 표시하고 변경할 객체 생성.
    // 이 화면에서 데이터를 수정하면 이 객체의 값을 변경하고
    // save 버튼을 누르면 실제 서버와 코어 데이터에 반영한다.
    self.tempData = [NSMutableArray arrayWithObjects:
                     OBJECT_VAL(self.album.title, @""),                     // kAlbumItemTitle,
                     OBJECT_VAL(self.album.published, [NSDate date]),       // kAlbumItemDate,
                     OBJECT_VAL(self.album.summary, @""),    // kAlbumItemSummary,
                     OBJECT_VAL(self.album.location, @""),    // kAlbumItemLocation,
                     OBJECT_VAL(self.album.access, @"public"),     // kAlbumItemAccess,
                     nil];
    
    // 날짜 포멧 설정
    // yyyy-MM-dd 형식
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
}

#pragma mark - Table view data source

// 화면에 표시한 셀은 갯수 - 앨범 정보 갯수 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kAlbumItemCount;
}

// 화면에 표시할 셀의 설정 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // 테이블 뷰 생성 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == kAlbumItemTitle) {
        // 앨범 타이틀 
        cell.textLabel.text = kAlbumItemTitleString;
        cell.detailTextLabel.text = [self.tempData objectAtIndex:kAlbumItemTitle];
    } else if (indexPath.row == kAlbumItemDate) {
        // 앨범의 대표 날짜 
        cell.textLabel.text = kAlbumItemDateString;
        cell.detailTextLabel.text = [self.dateFormatter  stringFromDate: [self.tempData objectAtIndex:kAlbumItemDate]];
    } else if (indexPath.row == kAlbumItemSummary) {
        // 앨범의 요약
        cell.textLabel.text = kAlbumItemSummaryString;
        cell.detailTextLabel.text = [self.tempData objectAtIndex:kAlbumItemSummary];
    } else if (indexPath.row == kAlbumItemLocation) {
        // 앨범 로케이션 정보 셀
        cell.textLabel.text = kAlbumItemLocationString;
        cell.detailTextLabel.text = [self.tempData objectAtIndex:kAlbumItemLocation];
        
    } else if (indexPath.row == kAlbumItemAccess) {
        // 앨범의 접근 권한 셀
        cell.textLabel.text = kAlbumItemAccessString;
        cell.detailTextLabel.text = [self.tempData objectAtIndex:kAlbumItemAccess];
    }
    
    return cell;
}

#pragma mark - Table view delegate

// 테이블 셀을 선택했을때 호출되는 메소드 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kAlbumItemTitle) {
        // 앨범 제목 셀을 선택하면
        // 제목을 수정하는 화면으로 이동
        
        // 수정을 위한 화면에 표시할 타입은 한줄 텍스트를 입력받을 화면 타입으로.
        InputViewController *viewController = [[InputViewController alloc] initWithType:kInputViewTypeTextField];
        viewController.delegate = self;
        // 콜백 메소드 호출때 사용할 사용자 데이터
        viewController.userInfo = [NSNumber numberWithInteger:kAlbumItemTitle];
        // 현재 값을 설정해서 입력란에 표시된 값
        viewController.currentValue = [self.tempData objectAtIndex:kAlbumItemTitle];
        // 화면 전환
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else if (indexPath.row == kAlbumItemDate) {
        // 앨범 대표 날짜 셀을 선택하면
        // 날짜을 수정하는 화면으로 이동

        InputViewController *viewController = [[InputViewController alloc] initWithType:kInputViewTypeDatePicker];
        viewController.delegate = self;
        viewController.userInfo = [NSNumber numberWithInteger:kAlbumItemDate];
        viewController.currentValue = [self.tempData objectAtIndex:kAlbumItemDate];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else if (indexPath.row == kAlbumItemSummary) {
        // 앨범 요약 셀을 선택하면
        // 요약 정보를 수정하는 화면으로 이동

        InputViewController *viewController = [[InputViewController alloc] initWithType:kInputViewTypeTextView];
        viewController.delegate = self;
        viewController.userInfo = [NSNumber numberWithInteger:kAlbumItemSummary];
        viewController.currentValue = [self.tempData objectAtIndex:kAlbumItemSummary];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else if (indexPath.row == kAlbumItemLocation) {
        // 앨범 로케이션 셀을 선택하면
        // 로케이션 정보를 수정하는 화면으로 이동

        InputViewController *viewController = [[InputViewController alloc] initWithType:kInputViewTypeTextField];
        viewController.delegate = self;
        viewController.userInfo = [NSNumber numberWithInteger:kAlbumItemLocation];
        viewController.currentValue = [self.tempData objectAtIndex:kAlbumItemLocation];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else if (indexPath.row == kAlbumItemAccess) {
        // 앨범 권한 셀을 선택하면
        // 권한 정보를 수정하는 화면으로 이동
        
        // OptionViewController은 파라미터로 주어진 선택 사항중에서 선택할 수 있도록
        // 테이블로 보여주는 화면이다. 이 화면에서 값을 선택하면 델리케이트로 선택한 값을 
        // 받을 수 있다.
        OptionViewController *viewController = 
            [[OptionViewController alloc] initWithTitle:kAlbumItemAccessString 
                                                options:[Setting stringsForAccessLevel]
                                          selectedIndex:[Setting accessLevelForString:
                                                            [self.tempData objectAtIndex:kAlbumItemAccess ]]];
        viewController.optionKind = kAlbumItemAccess;
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        
        [viewController release];
        
    }
}

// 변경한 내용을 서버와 코어 데이터에 저장.
- (void) onSave:(id)sender
{
    if( contextChanged )
    {
        // 값이 변경되었으면 

        // 피카사 서버를 통해서 현재 정보를 가져온다. 
        NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:self.album.account.userid
                                                                 albumID:nil
                                                               albumName:nil
                                                                 photoID:nil
                                                                    kind:nil
                                                                  access:nil];
        
        // 저장 중임을 화면에 표시 
        self.loadingView = [LoadingView loadingViewInView:self.view];
        self.loadingView.textLabel.text = @"Saving Album";
        
        [self.googlePhotoService fetchFeedWithURL:feedURL
                                completionHandler:^(GDataServiceTicket *ticket, GDataFeedBase *feed, NSError *error)
         {
             // 서버로 부터 현재 정보를 받으면 다음 코드가 실행됨.
             if (error == nil) {
                 GDataFeedPhotoUser *userFeed = (GDataFeedPhotoUser*) feed;
                 NSArray *albums = userFeed.entries;
                 GDataEntryPhotoAlbum *albumEntry = nil;
                 for(GDataEntryPhotoAlbum* entry in albums)
                 {
                     if([self.album.albumid isEqualToString:entry.GPhotoID])
                     {
                         albumEntry = entry;
                         break;
                     }
                 }
                 
                 // 현재 설정한 값으로 앨범 정보를 수정한다.
                 NSString *strOfTitle = [self.tempData objectAtIndex:kAlbumItemTitle];
                 NSString *strOfSummary = [self.tempData objectAtIndex:kAlbumItemSummary];
                 NSString *strOfAccess = [self.tempData objectAtIndex:kAlbumItemAccess];
                 NSString *strOfLocation = [self.tempData objectAtIndex:kAlbumItemLocation];
                 NSDate *dateOfAlbum = [self.tempData objectAtIndex:kAlbumItemDate];
                 
                 albumEntry.title = [GDataTextConstruct textConstructWithString: strOfTitle];
                 albumEntry.summary = [GDataTextConstruct textConstructWithString: strOfSummary];
                 albumEntry.timestamp = [GDataPhotoTimestamp timestampWithDate: dateOfAlbum];
                 albumEntry.location = strOfLocation;
                 albumEntry.access = strOfAccess;
                 
                 // 수정된 정보를 서버에 반영한다. 
                 [self.googlePhotoService fetchEntryByUpdatingEntry:albumEntry
                                                  completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *entry, NSError *error)
                  {
                      if(error == nil)
                      {
                          // 서버에 정보 갱신이 성공하면 내부의 코어 데이터의 정보도 변경한다.
                          self.album.title = strOfTitle;
                          self.album.published = dateOfAlbum;
                          self.album.summary = strOfSummary;
                          self.album.location = strOfLocation; 
                          self.album.access = strOfAccess;
                          
                          // save info
                          [self.album.managedObjectContext save:nil];
                          
                          [self.navigationController popViewControllerAnimated:YES];
                          
                          [self.loadingView removeView];
                          
                      }
                  }];
             }
         }];
        // update request
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark inputViewControllerDelegate Handler

// 값이 변경되면 호출되는 메소드
// userInfo에는 InputViewController을 호출할 당시에 설정했던 
// 사용자 데이터가 저장되어 있다. 
- (void) inputViewController:(InputViewController*)viewController 
                changedValue:(id)value 
                      ofType:(InputViewType)type 
                    userInfo:(id)userInfo
{
    if( [userInfo integerValue] == kAlbumItemTitle )
    {
        // 앨범명을 변경한 겂이면 변경된 값을 설정한다.
        [self.tempData replaceObjectAtIndex:kAlbumItemTitle withObject:value];
    } else if( [userInfo integerValue] == kAlbumItemDate )
    {
        // 앨범 날짜를 변경한 겂이면 변경된 값을 설정한다.
        [self.tempData replaceObjectAtIndex:kAlbumItemDate withObject:value];
    } else if( [userInfo integerValue] == kAlbumItemSummary )
    {
        // 앨범 요약 정보를 변경한 겂이면 변경된 값을 설정한다.
        [self.tempData replaceObjectAtIndex:kAlbumItemSummary withObject:value];
    } else if( [userInfo integerValue] == kAlbumItemLocation )
    {
        // 앨범 로케이션 정보를 변경한 겂이면 변경된 값을 설정한다.
        [self.tempData replaceObjectAtIndex:kAlbumItemLocation withObject:value];
    }
    
    // 값이 변경 되었으니 Save 버튼을 눌렸을때 정보를 갱신할 수 있도록 
    // 하기 위해서 플래그를 설정한다.
    contextChanged = YES;
    
    [self.tableView reloadData];


}

#pragma mark OptionViewControllerDelegate Handler

// 앨범의 접근 권한을 변경할였을때 호출되는 메소드 
- (void) optionView:(OptionViewController*)viewController isValueChanged:(NSInteger)selectedIndex
{
    if (viewController.optionKind == kAlbumItemAccess) {
        // 변경된 접근 권한을 설정한다.
        NSString *accessVal = [[Setting stringsForAccessLevel] objectAtIndex:selectedIndex];
        [self.tempData replaceObjectAtIndex:kAlbumItemAccess withObject:accessVal];
    }
    
    contextChanged = YES;
    [self.tableView reloadData];
}

@end
