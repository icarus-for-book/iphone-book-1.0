//
//  PhotoDetailViewController.h
//  iPicasaWebViewer
//
//  Created by jinni on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewController.h"
#import "LoadingView.h"

// 사진 메타 정보를 조회 및 수정할 화면 
@interface PhotoDetailViewController : UITableViewController<InputViewControllerDelegate> {
@private
    PhotoInfo *_photo;
    NSMutableArray *_tempData;
    NSDateFormatter *_dateFormatter;
    
    BOOL contextChanged;
    LoadingView *_loadingView;    
}
// 로딩 중임을 표시할 로딩 뷰
@property(nonatomic, retain) LoadingView *loadingView;

// 사진 정보를 가지고 있는 정보 객체
@property(nonatomic, retain) PhotoInfo *photo;

// 구글 서버에 요청할때 사용된 구글 서비스 객체
@property(nonatomic, retain) GDataServiceGooglePhotos *googlePhotoService;

@end
