//
//  CominInfo.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 24..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    kComicBookReadDone,  ///< 다 읽음
    kComicBookReading,   ///< 읽는 중 
    kComicBookReadNotYet ///< 잆지 않음.
};

typedef NSInteger ComicBookStatus;

@interface ComicInfo : NSObject <NSCoding> {
    NSString *path;             // 만화 압축 파일 경로 
    NSDate   *lastModified;     // 만화 파일의 최종 변경 시간 
    NSArray  *files;            // 만화 이미지 목록 
    NSInteger lastPage;         // 마지막으로 읽은 페이지 수
    NSDate   *lastAccess;       // 마지막으로 access 했던 시간
}

@property(nonatomic, retain) NSString  *path;
@property(nonatomic, retain) NSDate    *lastModified;
@property(nonatomic, retain) NSDate    *lastAccess;
@property(nonatomic, retain) NSArray   *files;
@property(nonatomic, assign) NSInteger lastPage;
 
// 책을 읽은 정보를 반환 
- (ComicBookStatus) readStatus;
// 만화 파일(Zip파일)에서 원하는 이미지의 Data를 가져온다.
- (NSData*) imageFilePathAt:(NSInteger)index;
// 읽은 정보 ( 0 ~ 100 % )
- (CGFloat) percentForRead;
// 현재의 정보파일과 주어진 path의 정보가 같은지 확인.
// file이 update되었는지 확인하기 위해서 사용.
- (BOOL) isEqualComic:(NSString*) path;

@end
