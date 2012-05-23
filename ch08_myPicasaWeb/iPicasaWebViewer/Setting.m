//
//  Setting.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 26..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Setting.h"

@interface Setting()
// 설정값을 가져오기
- (void) readSetting;

@end

@implementation Setting

@synthesize defaultPhotoSize = _defaultPhotoSize;
@synthesize albumSortOrder = _albumSortOrder;

+(id) sharedSetting
{
    static Setting* theInstance = nil;
    if (theInstance==nil) {
        @synchronized([Setting class])
        {
            if (theInstance == nil) {
                theInstance = [[Setting alloc]init];
            }
        }
    }
    
    return theInstance;
}

// DefaultPhotoSize 종류 문자열로 반환 
+ (NSString*) stringForDefaultPhotoSize:(DefaultPhotoSize)photosize
{
    switch (photosize) {
        case kPhotoSizeOrignal:
            return @"원래 크기"; 
        case kPhotoSize1600px:
            return @"1600px";
        case kPhotoSize1280px:
            return @"1280 px";
        case kPhotoSize1024px:
            return @"1024 px";
        case kPhotoSize800px:
            return @"800 px";
        case kPhotoSize640px:
            return @"640 px";
        case kPhotoSize512px:
            return @"512 px";
    }
    return nil;
}


// 만화 자름 모드 문자열로 반환 
+ (NSString*) stringForAlbumSortOrder:(AlbumSortOrder)sortOrder
{
    switch (sortOrder) {
        case kAlbumOrderAlbumname:
            return @"앨범 이름으로 정렬"; 
        case kAlbumOrderUpdateDate:
            return @"앨범 등록 날짜으로 정렬";
        case kAlbumOrderAlbumDate:
            return @"앨범 날짜로 절령";
    }
    return nil;
}

+ (NSArray*) stringsForAccessLevel
{
    return [[NSArray alloc] initWithObjects:@"public", @"protected", @"private",nil];
}

// access level for acess level string
+ (AccessLevel) accessLevelForString:(NSString*)levelString
{
    if([levelString isEqualToString:@"public"])
    {
        return kAccessLevelPublic;
    } else if([levelString isEqualToString:@"protected"])
    {
        return kAccessLevelProtected;
    } else if([levelString isEqualToString:@"private"])
    {
        return kAccessLevelPrivate;
    }
    
    return kAccessLevelPublic;
    
}

- (id) init
{
    self = [super init];
    if(self)
    {
        // set default setting
        NSDictionary* defaultValue = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:kAlbumOrderAlbumDate], @"albumSortOrder",
                                      [NSNumber numberWithInteger:kPhotoSize1600px], @"defaultPhotoSize",
                                      nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults registerDefaults:defaultValue];
        
        [self readSetting];
    }
    
    return self;
}

// 설정 값을 읽는다. 
- (void) readSetting
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _albumSortOrder = [defaults integerForKey:@"albumSortOrder"];
    _defaultPhotoSize = [defaults integerForKey:@"defaultPhotoSize"];
}

// 설정 값을 쓴다. 
- (void) flush
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setInteger:_albumSortOrder forKey:@"albumSortOrder"];
    [defaults setInteger:_defaultPhotoSize forKey:@"defaultPhotoSize"];

    [defaults synchronize];
}

// defaultPhotoSize가 내부의 기준으로 사이즈를 설정한 것이라면
// 실제로 구글에 요청할때는 구글의 기준의 다운 받은 최대 이미지 사이즈를
// 구해야 한다.
// defaultPhotoSize로 imgMax값을 구한다.
- (NSInteger) imageMaxSize
{
    NSInteger ret = kGDataGooglePhotosImageSizeDownloadable;
    
    
    switch (self.defaultPhotoSize) {
        case kPhotoSize1600px:
            ret = 1600;
            break;
        case kPhotoSize1280px:
            ret = 1280;
            break;
        case kPhotoSize1024px:
            ret = 1024;
            break;
        case kPhotoSize800px:
            ret = 800;
            break;
        case kPhotoSize640px:
            ret = 640;
            break;
        case kPhotoSize512px:
            ret = 512;
            break;
    }
    
    return ret;
}





@end

