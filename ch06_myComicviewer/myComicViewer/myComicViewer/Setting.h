//
//  Setting.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 26..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 화면 맞춤 종류 
enum {
    kFitScreenHorz,     ///< 가로 화면 맞춤
    kFitScreenVirt,     ///< 세로 화면 맞춤 
    kFitScreenBoth,     ///< 가로, 세로를 고려한 화면 맞춤
    kFitScreenNone,     ///< 화면 맞춤 하지 않음 
};

typedef NSInteger FitScreenMode;


// 만화 자름 모드
enum {
    kPageSplitNone,     ///< 만화 자르지 않음 
    // 양면을 가진 그림은 반으로 나눌 수 있음.
    // 0 | 1
    kPageSplitHorz,     ///< 좌우를 반으로 나눔 
    // 양면을 가진 그림은 반으로 나눌 수 있음.
    // 0
    // -
    // 1
    kPageSplitVirt,     ///< 상호를 반으로 나눔 
};

typedef NSInteger PageSplitMode;

// 만화를 어는 방향 
enum {
    kOpenDirRight,      ///< 한국형으로 오른쪽으로 진행하면서 읽는 책 방향 
    kOpenDirLeft,       ///< 일본형으로 왼쪽으로 진행하면서 읽는 책 방향 
};

typedef NSInteger OpenDirMode;

// 파일 목록 보기 모드 종류 
enum {
    kFileListBreifMode,     ///< 파일의 제목만 보여줌 
    kFileListDetailMode,    ///< 파일 이름, 파일 크기, 파일 수정 시간 보여줌 
};

typedef NSInteger FileListMode;

@class ComicInfo;

@interface Setting : NSObject 

// create shared setting object
+(id) sharedSetting;

@property(nonatomic,retain) NSMutableDictionary* comicInfos;

@property(nonatomic,assign,getter = isShowPage) BOOL showPage;
@property(nonatomic,assign) FitScreenMode fitScreen;
@property(nonatomic,assign) PageSplitMode pageSplitMode;
@property(nonatomic,assign,getter = isTransitionAnimation) BOOL transitionAnimation;
@property(nonatomic,assign) OpenDirMode openDirMode;
@property(nonatomic,assign,getter = isEnableZoom) BOOL enableZoom;
@property(nonatomic,assign) FileListMode fileListMode;

// 화면 맞춤 종류 문자열로 반환 
- (NSString*) stringForFitScreen:(FitScreenMode)fitScreenMode;
// 만화 자름 모드 문자열로 반환 
- (NSString*) stringForPageSplitMode:(PageSplitMode)pageSplitMode;
// 만화를 어는 방향 문자열로 반환 
- (NSString*) stringForFileListMode:(FileListMode)fileListMode;
// 파일 목록 보기 문자열로 반환 
- (NSString*) stringForOpenDirMode:(OpenDirMode)openDirMode;



@end
