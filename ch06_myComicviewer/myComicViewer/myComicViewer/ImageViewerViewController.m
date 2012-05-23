//
//  ImageViewerViewController.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageViewerViewController.h"
#import "ZipArchive.h"
#import "Setting.h"
#import "DetailViewController.h"
#import "ComicInfo.h"

@interface ImageViewerViewController()

// 다음장 넘기기.
- (void) nextPage;
// 이전장 넘기기.
- (void) prevPage;
// 마지막으로 보았던 page 보기
- (void) currentPage;

// 주어진 이미지를 subpage별로 나눈다.
- (UIImage*) splitImage:(UIImage*)image AtIndex:(NSInteger)index ofSplitType:(PageSplitMode)splitType;
// 현재 image
- (UIImage*) currentImage;
// 다음장 image
- (UIImage*) nextImage;
// 이전장 image
- (UIImage*) prevImage;

// 만화책파일에서 원하는 index의 data를 가져온다. 
- (NSData*) imageFilePathAt:(NSInteger)index;

// page 넘김 animation 실행.
- (void) movePage:(UIImage*)image directionToRight:(BOOL)rightDir;

// single tap을 했을때 호출.
// single tap을 하면 navigationbar를 훔기거나 보이게 한다.
- (void)tapGuestureHandler:(UIGestureRecognizer *)gestureRecognizer;

// detail button을 눌렸을때 호출.
// detail view를 호출
- (void)clickDetailBar;

@end


@implementation ImageViewerViewController

@synthesize curImageView;
@synthesize nextImageView;
@synthesize info;

- (void)dealloc
{
    [info release];
    [curImageView release];
    [nextImageView release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizerDirection leftDir = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizerDirection rightDir = UISwipeGestureRecognizerDirectionRight;
    
    // create navigation item
    
    UIBarButtonItem *detailBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(clickDetailBar)];
    self.navigationItem.rightBarButtonItem = detailBar;
    [detailBar release];
    
    // 마지막 보았던 page로 이동.
    // TODO 정확히 같은 page로 이동하지는 못함. 마지막으로 보았던 image의 첫번째 page로 이동한다. 이 부분 수정필요.
    subindex = 0;
    [self currentPage];
    
    // Sigle Tap Gesture 설정.
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuestureHandler:)];
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture release];
    
    // Swipe Gesture 설정. ( 다음장, 이전장 넘기 때 사용한 gesture )
    UISwipeGestureRecognizer *swipeRecognizer;
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    swipeRecognizer.direction = leftDir;
    [self.view addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    swipeRecognizer.direction = rightDir;
    [self.view addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];

}

- (void)viewDidUnload
{
    [self setCurImageView:nil];
    [self setNextImageView:nil];
    [super viewDidUnload];
}

// bar style변경
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

// bar style을 이전의 style로 변경.
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

// 다음장, 이전장을 넘기는 Gesture에 대한 Handler.
- (void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    Setting *setting = [Setting sharedSetting];
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {

        if(setting.openDirMode == kOpenDirLeft)
            [self prevPage];
        else
            [self nextPage];   
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if(setting.openDirMode == kOpenDirLeft)
            [self nextPage];
        else
            [self prevPage];   
    }
}

// 마지막으로 보았던 page를 표시
- (void) currentPage
{
    curImageView.hidden = NO;
    [curImageView displayImage:[self currentImage]];
    nextImageView.hidden = YES;
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", info.lastPage + 1, [info.files count]];
}

// 다음장 표시.
- (void) nextPage
{
    // nextPage가 더 있는지 검사 없으면 pop Navi
    if (info.lastPage + 1 >= info.files.count ) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // 실제로 페이지 넘김.
    Setting *setting = [Setting sharedSetting];
    [self movePage:[self nextImage] directionToRight:setting.openDirMode == kOpenDirRight];
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", info.lastPage + 1, [info.files count]];
    
    // 최상단으로 이동
    [self.curImageView setContentOffset:CGPointMake(0, 0) animated:YES];
}

// 이전장으로 넘기.
- (void) prevPage
{
    // nextPage가 더 있는지 검사 없으면 pop Navi
    if (info.lastPage - 1 < 0 ) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    // 실제로 페이지 넘김.
    Setting *setting = [Setting sharedSetting];
    [self movePage:[self prevImage] directionToRight:setting.openDirMode == kOpenDirLeft];
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", info.lastPage + 1, [info.files count]];

    // 최상단으로 이동
    [self.curImageView setContentOffset:CGPointMake(0, 0) animated:YES];
}

// 페이지 넘김.
// 페이지 넘기는 animation 및 image view 조정.
- (void) movePage:(UIImage*)image directionToRight:(BOOL)rightDir
{
    // nextPage가 있으면 nextImage를 오른쪽에 위치시키고 다음 페이지 이미지를 Load시킴 
    [nextImageView displayImage:image];
    
    if (rightDir) {
        // 오른쪽에서 왼쪽 방향으로 이동.
        // 한국형 책 넘김으로는 다음 페이지로 이동하는 것.
        
        CGRect nextImageFrame = curImageView.frame;
        nextImageFrame.origin.x = CGRectGetMaxX(curImageView.frame);
        nextImageView.frame = nextImageFrame;
        nextImageView.hidden = NO;
        
        // UIView animation으로 오른쪽으로 이동 시킴.
        Setting *setting = [Setting sharedSetting];
        if( setting.transitionAnimation == NO )
        {
            CGRect frame = curImageView.frame;
            nextImageView.frame = frame;
            frame.origin.x -= frame.size.width;
            curImageView.frame = frame;
            nextImageView.hidden = YES;
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                CGRect frame = curImageView.frame;
                nextImageView.frame = frame;
                frame.origin.x -= frame.size.width;
                curImageView.frame = frame;
            } completion:^(BOOL finished) {
                nextImageView.hidden = YES;
            }];
            
        }
    } else {
        // 왼쪽에서 오른쪽 방향으로 이동.
        // 한국형 책 넘김으로는 이전 페이지로 이동하는 것.
        
        CGRect nextImageFrame = curImageView.frame;
        nextImageFrame.origin.x -= CGRectGetMaxX(curImageView.frame);
        nextImageView.frame = nextImageFrame;
        nextImageView.hidden = NO;
        
        // UIView animation으로 왼쪽으로 이동 시킴.
        Setting *setting = [Setting sharedSetting];
        if( setting.transitionAnimation == NO )
        {
            CGRect frame = curImageView.frame;
            nextImageView.frame = frame;
            frame.origin.x += frame.size.width;
            curImageView.frame = frame;
            nextImageView.hidden = YES;
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                CGRect frame = curImageView.frame;
                nextImageView.frame = frame;
                frame.origin.x += frame.size.width;
                curImageView.frame = frame;
            } completion:^(BOOL finished) {
                nextImageView.hidden = YES;
            }];
        }
    }
    
    // curImage, nextImage를 swap 
    id tmp = curImageView;
    curImageView = nextImageView;
    nextImageView = tmp;
    
}


// 주어진 Offset만큼 page를 넘길때의 lastPage, subindex값 계산.
// +1이면 다음페이지.
// -1이면 이전페이지.
// WARN : 이외의 값들을 정상적으로 동작하지 않는다.
- (BOOL) calcNextPageOfOffset:(NSInteger)offset
{
    Setting *setting = [Setting sharedSetting];
    if (setting.pageSplitMode==kPageSplitNone) {
        info.lastPage += offset;
    } else {
        // info.lastPage, subindex를 활용.
        subindex += offset;
        
        if (subindex > 1) {
            subindex = 0;
            info.lastPage += 1;
        } if (subindex < 0 ) {
            subindex = 1;
            info.lastPage -= 1;
        }
        
    }
    
    return YES;
}

// 다음장으로 넘기때의 이미지 반환 
- (UIImage*) nextImage
{
    BOOL success = [self calcNextPageOfOffset:1];
    if (success == NO) {
        return nil;
    }
    
    Setting *setting = [Setting sharedSetting];
    UIImage *image = [UIImage imageWithData:[self imageFilePathAt:info.lastPage]];
    image = [self splitImage:image AtIndex:subindex ofSplitType:setting.pageSplitMode];

    NSLog(@"(%d,%d)", info.lastPage, subindex);
    return image;
}

// 이전장으로 넘기때의 이미지 반환.
- (UIImage*) prevImage
{
    BOOL success = [self calcNextPageOfOffset:-1];
    if (success == NO) {
        return nil;
    }
    Setting *setting = [Setting sharedSetting];
    UIImage *image = [UIImage imageWithData:[self imageFilePathAt:info.lastPage]];
    image = [self splitImage:image AtIndex:subindex ofSplitType:setting.pageSplitMode];
    
    NSLog(@"(%d,%d)", info.lastPage, subindex);
    return image;
}

// 현재 페이지 이미지 반환. 
- (UIImage*) currentImage
{
    BOOL success = [self calcNextPageOfOffset:0];
    if (success == NO) {
        return nil;
    }
    Setting *setting = [Setting sharedSetting];
    UIImage *image = [UIImage imageWithData:[self imageFilePathAt:info.lastPage]];
    image = [self splitImage:image AtIndex:subindex ofSplitType:setting.pageSplitMode];
    
    NSLog(@"(%d,%d)", info.lastPage, subindex);
    return image;
}

// 만화 파일(Zip파일)에서 원하는 이미지의 Data를 가져온다.
- (NSData*) imageFilePathAt:(NSInteger)index
{
    NSData *retImage = nil;
    ZipEntry* zipEntry = [info.files objectAtIndex:info.lastPage];
    ZipArchive* za = [[ZipArchive alloc] init];
    if([za UnzipOpenFile:info.path])
    {
        retImage = [za UnzipDataOfIndex:zipEntry.zipIndex];
        [za UnzipCloseFile];
    }
    [za release];
    
    return retImage;
}

// 이미지를 주어진 Split 방식에 따라서 나누어진 Image를 반환하다.
- (UIImage*) splitImage:(UIImage*)image AtIndex:(NSInteger)index ofSplitType:(PageSplitMode)splittype
{
    // 일본책의 경우 좌우 순서 보정.
    Setting *setting = [Setting sharedSetting];
    if(setting.openDirMode == kOpenDirLeft)
    {
        switch (splittype) {
            case kPageSplitHorz:
                index = 1 - index;
        }
    }
    
    
    CGRect drawFrame = CGRectMake(0, 0, [image size].width, [image size].height);
    CGSize imageSize = [image size];
    
    // 그릴 이미지의 위치 조정.
    switch (splittype) {
        case kPageSplitHorz:
            imageSize.width /= 2.0f;
            
            switch (index) {
                case 0:
                    break;
                case 1:
                    drawFrame.origin.x -= imageSize.width;
                    break;
            }
            break;
        case kPageSplitVirt:
            imageSize.height /= 2.0f;
            
            switch (index) {
                case 0:
                    break;
                case 1:
                    drawFrame.origin.y -= imageSize.height;
                    break;
            }
            break;
    }
    
    // 버퍼에 이미지를 그려서 원하는 이미지의 부분을 얻는다.
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:drawFrame];
    UIImage* splitedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return splitedImage;
}

// single tap을 했을때 호출.
// single tap을 하면 navigationbar를 훔기거나 보이게 한다.
- (void)tapGuestureHandler:(UIGestureRecognizer *)gestureRecognizer
{
    // toggle navigation bar
    BOOL isNavHidden = self.navigationController.navigationBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:!isNavHidden];
    [self.navigationController setNavigationBarHidden:!isNavHidden];
    self.curImageView.frame = self.view.bounds;
}

    
- (void)clickDetailBar
{
    DetailViewController *detailView = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailView.info = self.info;
    detailView.delegate = self;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];

}

#pragma mark -
#pragma mark DetailViewControllerDelegate handler

- (void)detailView:(DetailViewController *)viewController didSelected:(ComicInfo *)info
{
    subindex = 0;
    [self currentPage];
}

#pragma mark -
#pragma mark View controller rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // adjust frames and configuration of each visible page
    
    CGPoint restorePoint = [curImageView pointToCenterAfterRotation];
    CGFloat restoreScale = [curImageView scaleToRestoreAfterRotation];
    curImageView.frame = self.view.bounds;
    [curImageView setMaxMinZoomScalesForCurrentBounds];
    [curImageView restoreCenterPoint:restorePoint scale:restoreScale];
        
}


@end
