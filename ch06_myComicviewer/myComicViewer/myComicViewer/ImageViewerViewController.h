//
//  ImageViewerViewController.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicInfo.h"
#import "ImageScrollView.h"
#import "Setting.h"
#import "DetailViewController.h"

// 만화 이미지를 화면에 표시.
// 다음과 같은 기능을 제공한다.
//  - 주어진 page의 이미지를 화면에 표시한다.
//  - single tap을 하면 navigation bar를 hide시킨다.
//  - 주어진 image split mode에 따라서 이미지를 잘라서 보여준다.
//  - image를 확대/축소 할 수 있다.
//  - swipe를 통해서 다음/이전 페이지로 이동한다.
//  - 페이지 넘기는 방향을 설정에 따라서 변경한다. ( 한국형: 오른쪽 페이지가 다음장,  일본형: 왼쪽 페이지가 다음장)

@interface ImageViewerViewController : UIViewController <DetailViewControllerDelegate> {
    
    // 보여준 만화책 정보
    ComicInfo *info;
    
    // 현재 page를 보여주는 image View
    ImageScrollView *curImageView;
    // 다음 page를 보여주는 image view
    ImageScrollView *nextImageView;
    
    // 여러장의 page가 한 image에 포함되어 있을때 page를 표시하기 위한 index
    NSInteger subindex;
}

// outlets

@property (nonatomic, retain) IBOutlet ImageScrollView *curImageView;
@property (nonatomic, retain) IBOutlet ImageScrollView *nextImageView;
@property (nonatomic, retain) ComicInfo *info;


@end
