//
//  DetailViewController.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicInfo.h"

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

// detail view에서 page를 선택하면 호출됨.
// 선택한 index는 info.lastPage에 기록됨.
- (void) detailView:(DetailViewController*)viewController didSelected:(ComicInfo*) info;

@end

// 만화의 상세 정보를 보여주는 UI
// 아래와 같은 기능을 제공한다.
//   - 만화 Image 목록 표시
//   - 만환 Image를 선택해서 바로 볼 수 있는 기능.
@interface DetailViewController : UITableViewController {
	ComicInfo      *info;
    id<DetailViewControllerDelegate> _delegate;
}

@property(nonatomic, retain) ComicInfo      *info;
@property(nonatomic, assign) id<DetailViewControllerDelegate> delegate;
@end
