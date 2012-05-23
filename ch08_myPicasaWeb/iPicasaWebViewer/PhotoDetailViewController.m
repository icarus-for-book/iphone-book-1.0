//
//  PhotoDetailViewController.m
//  iPicasaWebViewer
//
//  Created by jinni on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoDetailViewController.h"

// 사진을 여러가지 섹션으로 구분하기 위한
// 섹션 인덱스
enum {
    kPhotoDetailSectionCaption,
    kPhotoDetailSectionFileName,
    kPhotoDetailSectionPhotoInfo,
    kPhotoDetailSectionCount,
};

// 섹션의 헤더 문자열들

#define kPhotoDetailSectionCaptionString @"사진 설명"
#define kPhotoDetailSectionFileNameString @"파일 이름"
#define kPhotoDetailSectionPhotoInfoString @"사진 정보"

// items of PhotoInfo section
enum {
    kPhotoDetailPhotoInfoDate,
    kPhotoDetailPhotoInfoWidth,
    kPhotoDetailPhotoInfoHeight,
    kPhotoDetailPhotoInfoFileSize,
    kPhotoDetailPhotoInfoCamera,
    kPhotoDetailPhotoInfoModel,
    kPhotoDetailPhotoInfoISO,
    kPhotoDetailPhotoInfoExposure,
    kPhotoDetailPhotoInfoAperture,
    kPhotoDetailPhotoInfoFocalLength,
    kPhotoDetailPhotoInfoFlashUsed,
    kPhotoDetailPhotoInfoLatitude,
    kPhotoDetailPhotoInfoLongitude,
    kPhotoDetailPhotoInfoOriginalTime,
    kPhotoDetailPhotoInfoCount
};

#define kPhotoDetailPhotoInfoDateString       @"날짜"
#define kPhotoDetailPhotoInfoWidthString      @"가로 크기"
#define kPhotoDetailPhotoInfoHeightString     @"세로 크기"
#define kPhotoDetailPhotoInfoFileSizeString   @"파일 사이즈"
#define kPhotoDetailPhotoInfoCameraString     @"카메라 제조사"
#define kPhotoDetailPhotoInfoModelString      @"모델"
#define kPhotoDetailPhotoInfoISOString        @"ISO"
#define kPhotoDetailPhotoInfoExposureString   @"노출 시간"
#define kPhotoDetailPhotoInfoApertureString   @"조리개"
#define kPhotoDetailPhotoInfoFocalLengthString    @"초점거리"
#define kPhotoDetailPhotoInfoFlashUsedString      @"스트로브 사용"
#define kPhotoDetailPhotoInfoLatitudeString       @"위도"
#define kPhotoDetailPhotoInfoLongitudeString      @"경도"
#define kPhotoDetailPhotoInfoOriginalTimeString   @"촬영 시간"

// x가 nil이면 obj가 반환되는 매크로 
#define DEFAULT_STRVAL(x, obj)   ((x == nil) || ([x length] == 0)) ? obj : (x)

// 비공개 프로퍼티 및 메소드
@interface PhotoDetailViewController()

@property(nonatomic, retain) NSMutableArray *tempData;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;

- (void) onSave:(id)sender;

@end

@implementation PhotoDetailViewController

@synthesize loadingView = _loadingView;
@synthesize photo = _photo;
@synthesize tempData = _tempData;
@synthesize dateFormatter = _dateFormatter;
@synthesize googlePhotoService = _googlePhotoService;

- (void)dealloc
{    
    [_loadingView release];
    [_googlePhotoService release];
    [_dateFormatter release];
    [_tempData release];
    [_photo release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // title
    self.navigationItem.title = self.photo.title;
    
    // save 버튼 
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // setup temporary data
    self.tempData = [NSMutableArray arrayWithObjects:
                     DEFAULT_STRVAL(self.photo.summary, @""),           // kPhotoDetailSectionCaption
                     DEFAULT_STRVAL(self.photo.title,@""),              // kPhotoDetailSectionFileName,
                     nil];
    
    // setup date formatter
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
}

#pragma mark - Table view data source

// 표시할 섹션의 갯수
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 총 3개의 정보 섹션으로 구분하여 섹션을 3개 표시한다 지정
    return kPhotoDetailSectionCount;
}

// 섹션별 표시할 셀의 갯수 지정.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kPhotoDetailSectionCaption:
        case kPhotoDetailSectionFileName:
            return 1;
        case kPhotoDetailSectionPhotoInfo:
            return kPhotoDetailPhotoInfoCount;
    }
    return 0;
}

// 테이블 셀 생성 및 설정.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // 테이틀 셀 생성 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    if (indexPath.section == kPhotoDetailSectionCaption) {
        // 캡션 섹션의 셀이면 다음과 같이 설정한다.
        
        NSString *caption = [self.tempData objectAtIndex:kPhotoDetailSectionCaption];
        if ([caption length] > 0) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [self.tempData objectAtIndex:kPhotoDetailSectionCaption];
        } else {
            // caption이 없을때 
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.text = @"Caption";
        }
        
        cell.detailTextLabel.text = @"";
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;

    } else if (indexPath.section == kPhotoDetailSectionFileName) {
        // 파일명 섹션의 셀인경우 다음과 같이 설정한다.

        cell.textLabel.text = [self.tempData objectAtIndex:kPhotoDetailSectionFileName];
        cell.detailTextLabel.text = @"";
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;

    } else if (indexPath.section == kPhotoDetailSectionPhotoInfo) {
        // 사진 정보 섹션인 경우 다음과 같이 설정한다.
        
        cell.accessoryType =  UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        
        if (indexPath.row == kPhotoDetailPhotoInfoDate)
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoDateString;
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.photo.updated];
            
        } else if (indexPath.row == kPhotoDetailPhotoInfoWidth )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoWidthString;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.photo.width];
        } else if (indexPath.row == kPhotoDetailPhotoInfoHeight )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoHeightString;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.photo.height];

        } else if (indexPath.row == kPhotoDetailPhotoInfoFileSize )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoFileSizeString;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ B", self.photo.fileSize];
        } else if (indexPath.row == kPhotoDetailPhotoInfoCamera )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoCameraString;
            cell.detailTextLabel.text = self.photo.camera;
        } else if (indexPath.row == kPhotoDetailPhotoInfoModel )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoModelString;
            cell.detailTextLabel.text = self.photo.model;
        } else if (indexPath.row == kPhotoDetailPhotoInfoISO )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoISOString;
            cell.detailTextLabel.text = self.photo.iso;

        } else if (indexPath.row == kPhotoDetailPhotoInfoExposure )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoExposureString;
            cell.detailTextLabel.text = self.photo.exposure;

        } else if (indexPath.row == kPhotoDetailPhotoInfoAperture )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoApertureString;
            cell.detailTextLabel.text = self.photo.aperture;

        } else if (indexPath.row == kPhotoDetailPhotoInfoFocalLength )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoFocalLengthString;
            cell.detailTextLabel.text = self.photo.focalLength;

        } else if (indexPath.row == kPhotoDetailPhotoInfoFlashUsed )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoFlashUsedString;
            cell.detailTextLabel.text = [self.photo.flashUsed boolValue] ? @"YES" : @"NO";
        } else if (indexPath.row == kPhotoDetailPhotoInfoLatitude )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoLatitudeString;
            cell.detailTextLabel.text = DEFAULT_STRVAL(self.photo.latitude, @"N/A");
        } else if (indexPath.row == kPhotoDetailPhotoInfoLongitude )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoLongitudeString;
            cell.detailTextLabel.text = DEFAULT_STRVAL(self.photo.longitude, @"N/A");
        } else if (indexPath.row == kPhotoDetailPhotoInfoOriginalTime )
        {
            cell.textLabel.text = kPhotoDetailPhotoInfoOriginalTimeString;
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.photo.originalTime];

        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

// 사진 정보는 수정할 수 없는 정보이므로 선택할 수 없도록 한다.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPhotoDetailSectionPhotoInfo) {
        return nil;
    }
    
    return indexPath;
}

// 셀이 선택되었을때 데이터를 수정할 수 있도록 수정하는 화면으로 전환한다.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPhotoDetailSectionCaption) {
        // 캡션을 수정하려고 하면
        // InputViewController를 하나 만들고 화면 전환시킨다. 이때 캡션을 변환시켭다는 것을 
        // 델리케이터의 핸들러에서 구별할수 있도록 userInfo값을 설정한다.
        InputViewController *viewController = [[InputViewController alloc] initWithType:kInputViewTypeTextView];
        viewController.delegate = self;
        viewController.userInfo = [NSNumber numberWithInteger:kPhotoDetailSectionCaption];
        viewController.currentValue = [self.tempData objectAtIndex:kPhotoDetailSectionCaption];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    } else if (indexPath.section == kPhotoDetailSectionFileName) {
        // 파일명을 수정하려고 할때 
        InputViewController *viewController = [[InputViewController alloc] initWithType:kInputViewTypeTextField];
        viewController.delegate = self;
        viewController.userInfo = [NSNumber numberWithInteger:kPhotoDetailSectionFileName];
        viewController.currentValue = [self.tempData objectAtIndex:kPhotoDetailSectionFileName];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

// 사진의 메타정보를 구글 서버와 코어 데이터에 반영하는 메소드
- (void) onSave:(id)sender
{
    if( contextChanged )
    {
        // album 정보 조회해서 사진의 현재 정보값들을 구한다.
        NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:self.photo.album.account.userid
                                                                 albumID:self.photo.album.albumid
                                                               albumName:nil
                                                                 photoID:nil
                                                                    kind:nil
                                                                  access:nil];
       
        self.loadingView = [LoadingView loadingViewInView:self.view];
        self.loadingView.textLabel.text = @"Saving Photo";
        
        // 앨범 정보를 구글 서버에 요청함.
        [self.googlePhotoService fetchFeedWithURL:feedURL
                                completionHandler:^(GDataServiceTicket *ticket, 
                                                    GDataFeedBase *feed, 
                                                    NSError *error)
         {
             if (error == nil) {
                 // 구글의 앨범 정보 중에서 특정 사진 정보를 찾는다.
                 GDataFeedPhotoAlbum *albumFeed = (GDataFeedPhotoAlbum*) feed;
                 NSArray *photos = albumFeed.entries;
                 GDataEntryPhoto *photoEntry = nil;
                 for(GDataEntryPhoto* entry in photos)
                 {
                     if([self.photo.photoid isEqualToString:entry.GPhotoID])
                     {
                         photoEntry = entry;
                         break;
                     }
                 }
                 
                 // 사진 정보들의 값을 갱신시킨다.
                 photoEntry.title = [GDataTextConstruct textConstructWithString: [self.tempData objectAtIndex:kPhotoDetailSectionFileName]];
                 photoEntry.summary = [GDataTextConstruct textConstructWithString: [self.tempData objectAtIndex:kPhotoDetailSectionCaption]];
                 [self.googlePhotoService fetchEntryByUpdatingEntry:photoEntry
                                                  completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *entry, NSError *error)
                  {
                      if(error == nil)
                      {
                          // 코어데이터의 값을 갱신한다.
                          self.photo.title = [self.tempData objectAtIndex:kPhotoDetailSectionFileName];
                          self.photo.summary = [self.tempData objectAtIndex:kPhotoDetailSectionCaption];
                          [self.loadingView removeView];
                          [self.navigationController popViewControllerAnimated:YES];
                          [self.photo.managedObjectContext save:nil];
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

// 값이 변경되면 호출되는 함수
- (void) inputViewController:(InputViewController*)viewController changedValue:(id)value ofType:(InputViewType)type userInfo:(id)userInfo;
{
    if( [userInfo integerValue] == kPhotoDetailSectionCaption )
    {
        [self.tempData replaceObjectAtIndex:kPhotoDetailSectionCaption withObject:value];
    } else if( [userInfo integerValue] == kPhotoDetailSectionFileName )
    {
        [self.tempData replaceObjectAtIndex:kPhotoDetailSectionFileName withObject:value];
    }
    
    contextChanged = YES;
    
    [self.tableView reloadData];
}


@end
