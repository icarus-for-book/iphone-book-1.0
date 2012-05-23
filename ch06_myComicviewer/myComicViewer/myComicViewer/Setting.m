//
//  Setting.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 26..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Setting.h"


@implementation Setting


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

- (id) init
{
    self = [super init];
    if(self)
    {
        // set default setting
        NSDictionary* defaultValue = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:NO], @"showPage",
                                      [NSNumber numberWithInteger:kFitScreenBoth], @"fitScreen",
                                      [NSNumber numberWithInteger:kPageSplitNone], @"pageSplitMode",
                                      [NSNumber numberWithBool:YES], @"transitionAnimation",
                                      [NSNumber numberWithInteger:kOpenDirRight], @"openDirMode",
                                      [NSNumber numberWithBool:YES], @"enableZoom",
                                      [NSNumber numberWithInteger:kFileListBreifMode], @"fileListMode",
                                      nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults registerDefaults:defaultValue];
        
    }
    
    return self;
}


- (NSMutableDictionary *)comicInfos
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [defaults objectForKey:@"comicInfos"];
    
    if (data == nil ) {
        return [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    id ret = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return ret;
}

- (void)setComicInfos:(NSMutableDictionary *)value
{
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:value];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"comicInfos"];
    [defaults synchronize];
}

- (BOOL)isShowPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL val = [defaults boolForKey:@"showPage"];
    return val;
}
- (void)setShowPage:(BOOL)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:val forKey:@"showPage"];
    [defaults synchronize];
}


- (FitScreenMode)fitScreen
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger val = [defaults integerForKey:@"fitScreen"];
    return val;
}
- (void)setFitScreen:(FitScreenMode)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:val forKey:@"fitScreen"];
    [defaults synchronize];
}


-(PageSplitMode)pageSplitMode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger val = [defaults integerForKey:@"pageSplitMode"];
    return val;
}
- (void)setPageSplitMode:(PageSplitMode)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:val forKey:@"pageSplitMode"];
    [defaults synchronize];
}


- (BOOL)isTransitionAnimation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL val = [defaults boolForKey:@"transitionAnimation"];
    return val;
}
- (void)setTransitionAnimation:(BOOL)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:val forKey:@"transitionAnimation"];
    [defaults synchronize];
}


- (OpenDirMode)openDirMode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger val = [defaults integerForKey:@"openDirMode"];
    return val;
}
- (void)setOpenDirMode:(OpenDirMode)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:val forKey:@"openDirMode"];
    [defaults synchronize];
}

- (BOOL)isEnableZoom
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL val = [defaults boolForKey:@"enableZoom"];
    return val;
}
- (void)setEnableZoom:(BOOL)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:val forKey:@"enableZoom"];
    [defaults synchronize];
}


- (FileListMode)fileListMode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger val = [defaults integerForKey:@"fileListMode"];
    return val;
}
- (void)setFileListMode:(FileListMode)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:val forKey:@"fileListMode"];
    [defaults synchronize];
}


// 화면 맞춤 종류 문자열로 반환 
- (NSString*) stringForFitScreen:(FitScreenMode)fitScreenMode
{
    switch (fitScreenMode) {
        case kFitScreenHorz:     ///< 가로 화면 맞춤
            return @"가로 화면 맞춤"; 
        case kFitScreenVirt:     ///< 세로 화면 맞춤 
            return @"세로 화면 맞춤"; 
        case kFitScreenBoth:     ///< 가로, 세로를 고려한 화면 맞춤
            return @"맞춤"; 
        case kFitScreenNone:     ///< 화면 맞춤 하지 않음 
            return @"화면맞춤하지않음"; 
    }
    
    return nil;
    
}
// 만화 자름 모드 문자열로 반환 
- (NSString*) stringForPageSplitMode:(PageSplitMode)pageSplitMode
{
    switch (pageSplitMode) {
        case kPageSplitNone:
            return @"자르지 않음";
        case kPageSplitHorz:
            return @"좌우를 반으로 나눔"; 
        case kPageSplitVirt:     
            return @"상하를 반으로 나눔";
    }
    return nil;
}
// 만화를 어는 방향 문자열로 반환 
- (NSString*) stringForFileListMode:(FileListMode)fileListMode
{
    
    switch (fileListMode) {

        case kFileListBreifMode:
            return @"간략하게";
        case kFileListDetailMode:
            return @"상세하게";
    }
    return nil;
}
// 파일 목록 보기 문자열로 반환 
- (NSString*) stringForOpenDirMode:(OpenDirMode)openDirMode
{
    
    switch (openDirMode) {
        case kOpenDirRight:
            return @"오른쪽으로 넘김(한국형)"; 
        case kOpenDirLeft:
            return @"왼쪽으로 넘김(일본형)";
    }
    return nil;
}

@end

