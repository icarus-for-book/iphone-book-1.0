//
//  Setting.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 26..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Access Level

enum {
    kAccessLevelPublic,
    kAccessLevelProtected,
    kAccessLevelPrivate,
    kAccessLevelCount
};

typedef NSInteger AccessLevel;

// Photo Size
enum {
    kPhotoSizeOrignal,
    kPhotoSize1600px,
    kPhotoSize1280px,
    kPhotoSize1024px,
    kPhotoSize800px,
    kPhotoSize640px,
    kPhotoSize512px,
    kPhotoSizeCount
};

typedef NSInteger DefaultPhotoSize;

// Album Sort Order
enum {
    kAlbumOrderAlbumname,       // 앨범 이름으로 정렬
    kAlbumOrderUpdateDate,      // 사진을 올린 날짜로 정렬
    kAlbumOrderAlbumDate,       // 앨범을 찍은 날짜 정렬 
};

typedef NSInteger AlbumSortOrder;


// Setting Model.
@interface Setting : NSObject 
{
    DefaultPhotoSize _defaultPhotoSize;
    AlbumSortOrder   _albumSortOrder;
    
}

@property(nonatomic,assign) DefaultPhotoSize defaultPhotoSize;
@property(nonatomic,assign) AlbumSortOrder albumSortOrder;

- (NSInteger) imageMaxSize;

// 임시로 저장한 설정 값을 disk에 쓰기
// @note 값을 변경하고 flush를 하지 않으면 변경 내용을 저장되지 
//       않을수 있습니다.
- (void) flush;


// create shared setting object
+(id) sharedSetting;
// DefaultPhotoSize 종류 문자열로 반환 
+ (NSString*) stringForDefaultPhotoSize:(DefaultPhotoSize)photosize;
// 만화 자름 모드 문자열로 반환 
+ (NSString*) stringForAlbumSortOrder:(AlbumSortOrder)sortOrder;
// access strings
+ (NSArray*) stringsForAccessLevel;
// access level for acess level string
+ (AccessLevel) accessLevelForString:(NSString*)levelString;


@end
