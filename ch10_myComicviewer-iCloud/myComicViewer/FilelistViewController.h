//
//  FilelistViewController.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"

// 만화 파일을 삭제하고자 할때 호출되는 Notification name.
// 삭제를 원하는 파일 경로를 notification.object 에서 설정해주어야 한다.
#define kComicFileDeleteNotification @"ComicFileDeleted"

@class FtpServer;


// 주어진 경로 ( 기본 값을 Document )의 만화 목록 (.zip)을 화면에
// 표시하고 선택한 만화의 상세 정보 혹은 만화를 보여주는 화면으로 이동
// 시킨다.
@interface FilelistViewController : UITableViewController<UIAlertViewDelegate> {
 
    // 만화 파일로 인정하는 확장자 (현재는 zip 파일만)
	NSArray *extensions;
    // 만화 이미지 파일 확장자
    NSArray *allowImages;
    // 현재 Directory의 만화파일 이름들.
	NSMutableArray *files;
    
    // 클라우드 파일 조회를 위해서
    NSMetadataQuery *query;
    
    // Current Directory Path
    NSString *path;
    
    // 만화의 상세 정보.
    NSMutableDictionary *comicInfos;
    
    // 파일 리시트 표시 Style
    // - brief   : 파일명만 표시
    // - detail  : 파일명과 마지만 access time 표시
    FileListMode fileListMode;

    // FTP Server
    FtpServer *theServer;
}

// Ftp Server
@property (nonatomic, retain) FtpServer *theServer;


// 현재 검색한 경로
@property (nonatomic, copy)   NSString *path;
// 검색된 파일 목록.
@property (nonatomic, retain) NSMutableArray *files;
// 검색된 디렉토리 목록.
@property (nonatomic, retain) NSMutableArray *dirs;
// 만화 목록 정보 List로 새로 갱신되는 정보가 있으면 이 변수를 수정해야 한다.
@property (nonatomic, retain) NSMutableDictionary *comicInfos;

// setting Button을 눌렸을때 호춤될는 event handler
- (IBAction)clickSetting;
// upload button을 눌렸을때 호출되는 event handler
- (IBAction)uploadComic;
// "짬한 만화" 보기화면으로 전환
- (IBAction)showFavorite:(id)sender;


@end
