//
//  CommentViewController.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableHeaderView.h"
#import "AddCommentViewController.h"

// 댓글 보기 화면
@interface CommentViewController : UITableViewController<AddCommentViewControllerDelegate> {
    // View
    RefreshTableHeaderView *refreshHeaderView;
    
    // Model
    BOOL checkForRefresh;
    BOOL reloading;
}

// 화면에 표시할 대글 목록
@property(nonatomic, retain) NSArray *comments;

// 댓글 정보를 조회할때 사용할 구글 서비스 객체
@property(nonatomic, retain) GDataServiceGooglePhotos *googlePhotoService;

// 댓글을 가져올 사진 정보( 댓글은 사진에 연관되어 있는 정보다 ) 
@property(nonatomic, retain) PhotoInfo *photo;

@end
