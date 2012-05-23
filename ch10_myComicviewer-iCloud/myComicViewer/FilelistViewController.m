//
//  FilelistViewController.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilelistViewController.h"
#import "DetailViewController.h"
#import "SettingViewController.h"
#import "ImageViewerViewController.h"
#import "ComicInfo.h"
#import "ZipArchive.h"
#import "Utility.h"
#import "LoadingView.h"
#import "NetworkInfo.h"
#import "FtpServer.h"
#import "FavoriteListViewController.h"



// private methods
@interface FilelistViewController(PrivateMethod)

// 파일 목록을 갱신한다. 
- (void)reloadData;

// 주어긴 경로의 파일(만화파일)의 정보를 구한다.
// 만화파일의 상세 정보를 조회한다. 
//  - last access time
//  - 만화 파일 리스트
- (ComicInfo*) comicInfoOfSelected:(NSString *)path;
// 만화 파일 삭제.
- (void) ComicFileDelete:(NSString*) pathOfItem;
// file 데이터 설정.
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
// FTP Server 중지
- (void)stopFtpServer;

@end


@implementation FilelistViewController

@synthesize path;
@synthesize files;
@synthesize comicInfos;
@synthesize theServer;

- (void)awakeFromNib
{
    files = [[NSMutableArray alloc] init];

    // 만화파일로 인정하는 확장자는 현재는 zip만 허용.
    extensions = [[NSArray alloc] initWithObjects:@"zip", nil];
    allowImages = [[NSArray alloc] initWithObjects:@"jpg",@"png",@"jpeg",@"gif",@"bmp",@"gif", nil];

}

- (void)dealloc
{
    [extensions release];
    [files release];
    [path release];
    [allowImages release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set title
    self.navigationItem.title = @"만화목록";
    
    // add upload button
    UIBarButtonItem *uploadBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(uploadComic)];
    self.navigationItem.rightBarButtonItem = uploadBar;
    [uploadBar release];
    
    // 찜한 그림 보기 버튼
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithTitle:@"찜보기" style:UIBarButtonItemStyleBordered target:self action:@selector(showFavorite:)];
    self.navigationItem.leftBarButtonItem = favoriteButton;
    [favoriteButton release];
    
    
    // set default path if current path is null
    if (self.path == nil || [self.path length] == 0) {
        self.path = [[Utility applicationDocumentsDirectory] path];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // read file list mode from setting
    Setting* setting = [Setting sharedSetting];
    fileListMode = setting.fileListMode;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 화면이 보이려고 할때마다 현재 파일들을 다시 update 시킨다.
    [self reloadData];
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 세로 화면만 허용.
    return YES;
}

#pragma mark - Table view data source{
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // table에 사용할 Cell을 생성 
    NSString *CellIdentifier = @"briefCell";
    UITableViewCellStyle cellStyle = UITableViewCellStyleValue1;
    
    if (fileListMode == kFileListDetailMode ) {
        CellIdentifier = @"detailCell";  
        cellStyle = UITableViewCellStyleSubtitle;
    } 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Cell에 표시한 내용을 구한다.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(indexPath.section == 0)
        {
            //local files
            
            // delete comic file
            NSString *filepath = [self.path stringByAppendingPathComponent:[files objectAtIndex:indexPath.row]];
            [self ComicFileDelete:filepath];
            [self.files removeObjectAtIndex:indexPath.row];
            
            // Delete the row from the data source
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } 
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // table view를 사용자 반응을 하지 못하도록 함. 이상 동작 방지 
    [self.tableView setUserInteractionEnabled:NO];
    
    // Loading 화면 표시
    LoadingView *loadingView = [LoadingView loadingViewInView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *filePath = nil;
        filePath = [self.path stringByAppendingPathComponent:[files objectAtIndex:indexPath.row]];
        
        // 만화 상세 정보 조회
        ComicInfo* info = [self comicInfoOfSelected:filePath];
        
        // Loading 화면 제거 
        [loadingView removeView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI thread에서 다음 화면 전환를 한다.
            // UI 관련 작업은 반드시 UI Thread에서 해야 한다. 
            
            NSString *NibName = @"ImageViewerViewController";
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                NibName = @"ImageViewerViewController-iPad";
            }
            ImageViewerViewController *viewController = [[ImageViewerViewController alloc] initWithNibName:NibName bundle:nil];
            viewController.info = info;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            
            // 사용자 반응 다시 활성화 
            [self.tableView setUserInteractionEnabled:YES];
        });
        
    });
}


// 상세 보기 button을 클릭하면 상세화면(DetailViewController)로 화면을 넘김.
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ComicInfo* info = [self comicInfoOfSelected:[self.path stringByAppendingPathComponent:[files objectAtIndex:indexPath.row]]];
    DetailViewController *detailView = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailView.info = info;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
}


#pragma mark - hanlder


// 설정 화면으로 이동.
- (IBAction)clickSetting
{
    SettingViewController *viewController = 
        [[SettingViewController alloc] 
         initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];    
}

// upload button을 눌렸을때 호출되는 event handler
- (IBAction)uploadComic
{
    NetworkInfo* network = [[NetworkInfo alloc] init];
    [network update];
    
	NSString *localIPAddress = network.wifiAddress;
    [network release];
    NSInteger ftpPort = 30000;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FTP 서버 동작 중" 
													message:[NSString stringWithFormat:@"FTP client를 사용해서 데이터를 전송해주세요. \n서버:%@ 포트:%d", localIPAddress, ftpPort]
												   delegate:self 
										  cancelButtonTitle:@"서버 중지" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
    
    NSString *baseDir = [[Utility applicationDocumentsDirectory] path];
    
	FtpServer *aServer = [[ FtpServer alloc ] initWithPort:ftpPort withDir:baseDir notifyObject:self ];
	self.theServer = aServer;
	[aServer release];    
}

#pragma mark - ftp handler


- (void)didReceiveFileListChanged
{
    [self reloadData];
}

// FTP 서버 중지 버튼이 클릭되었을때 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self stopFtpServer];
}


@end

@implementation FilelistViewController(PrivateMethod)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSString *filename = [files objectAtIndex:indexPath.row];
    NSString *selectedFilePath = [self.path stringByAppendingPathComponent:filename];
    ComicInfo* info = [self.comicInfos objectForKey:selectedFilePath];

    // local files
    // 파일명, 마지막으로 읽은 시간을 표시하다.
    cell.textLabel.text = filename;
    if (info && [info percentForRead] > 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %%", (int)ceil([info percentForRead])];
    }
    
    // set reading status ( icon 으로 표시 )
    cell.imageView.image = [UIImage imageNamed:@"markReadNot.png"];
    if (info != nil) {
        ComicBookStatus status = [info readStatus];
        if ( status == kComicBookReading ) 
        {
            cell.imageView.image = [UIImage imageNamed:@"markReading.png"];
        } else if( status == kComicBookReadDone )
        {
            cell.imageView.image = [UIImage imageNamed:@"markReadDone.png"];
        }
    }
    
}


// 현재 디렉토리에서 만화파일로 허용된 확장장를 가진 파일 목록을 update 시킨다.
- (void)reloadData
{
    // File Manager 생성 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path] == NO){
        return;
    }
    
    // 주어진 경로의 파일들을 조회
    NSArray *tempArray = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:path error:NULL]];
    [files removeAllObjects];

    // 주어진 경로에 있는 파일과 폴더를 구분해서 
    // 폴더는 dirs에 파일을 files에 저장한다. 
    for (NSString *file in tempArray)
    {
        BOOL isDir;
        BOOL exists = [fileManager fileExistsAtPath:file isDirectory:&isDir];
        if (exists && isDir) {
            // skip directories.
        } else if (extensions != nil && [extensions count] > 0) {
            NSString *extension = [[file pathExtension] lowercaseString];
            if ([extensions containsObject:extension]) {
                [files addObject: file];
            }
        }
    }
    
    // table를 갱신한다.
    [self.tableView reloadData];
    [tempArray release];
}
                     

// table에서 선택한 만화의 상세 정보를 구함.
// 이미 정보가 있다면 메모리에서 아니면 파일로 부터 정보를 추출한다.
- (ComicInfo*) comicInfoOfSelected:(NSString *)filepath
{
    // check comic info in memory
    
    NSString *filename = [filepath lastPathComponent];
    
    if ( [self.comicInfos valueForKey:filename] != nil) {
        ComicInfo* info = [self.comicInfos valueForKey:filename];
        
        if ([info isEqualComic:filepath]) {
            // 기존의 정보와 같은 파일인 경우 cache의 Data를 반환 
            info.lastAccess = [NSDate date];
            return info;
        }
    }
    
    // if no, extract info from file.
    ComicInfo* info = [[ComicInfo alloc] init];
    info.path = filepath;
    info.lastAccess = [NSDate date];
    info.lastModified = [Utility lastModifiedDateForPath:filepath];
                         
    
    // read files in zip file
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile:filepath]) {

        info.files = [za UnzipFileList:allowImages];
        [za UnzipCloseFile];
    }
    [za release];
    
    [self.comicInfos setObject:info forKey:filename];
    return [info autorelease];
}

// 만화 파일 삭제.
- (void) ComicFileDelete:(NSString*) pathOfItem
{
    // delete comic file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:pathOfItem error:&error];
    
    // delete info 
    [self.comicInfos removeObjectForKey:pathOfItem];
}

- (void)stopFtpServer
{
	if(theServer)
	{
		[theServer stopFtpServer];
		[theServer release];
		theServer=nil;
	}    
}

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



- (IBAction)showFavorite:(id)sender
{
    FavoriteListViewController *viewController = [[FavoriteListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [viewController release];
}




@end
