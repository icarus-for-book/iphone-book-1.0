//
//  icomicviewerAppDelegate.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ComicInfo.h"
#import "FilelistViewController.h"
#import "Setting.h"

// Cloud API를 지원하는지 확인.
//
// NSUbiquitousKeyValueStore는 iOS 5.0 이후에서만 지원하므로
// iOS5.0 이상임을 확인하기 좋은 클래스다
BOOL IsSupportCloudAPI()
{
    return NSClassFromString(@"NSUbiquitousKeyValueStore") != nil;
}


@implementation AppDelegate

@synthesize filelistViewController;

@synthesize window=_window;

@synthesize viewController=_viewController;

// key-value 값이 변경되었을때 호출되는 콜백 함수
- (void) updateKeyValue:(NSNotification*)notification
{
    NSMutableDictionary *comicInfos = self.filelistViewController.comicInfos;
    NSArray *changedKeys = [[notification userInfo] objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    
    for (NSString *filename in comicInfos)
    {
        if ([changedKeys containsObject:filename]) {
            ComicInfo *info = [comicInfos objectForKey:filename];
            NSNumber *lastpage = [cloudKeyStore objectForKey:filename];
            info.lastPage = [lastpage integerValue];
            break;
        }
    }
}

// iCloud Key-Value Storage 초기화
- (void) setupKeyValueCloud
{
    // iCloud가 지원하지 않으면 Setup 하지 않음.
    if(! IsSupportCloudAPI()) return;
    
    // Key-Value Storage API가 있는지 확인.
    // Cloud API들을 iOS 5.0 이상에서만 사용할 수 있다.
        
    // Key-value Stroage 객체를 구한다.
    cloudKeyStore = [NSUbiquitousKeyValueStore defaultStore];
    
    // NSUbiquitousKeyValueStoreDidChangeExternallyNotification로
    // 노티피케이션 핸들러 등록
    
    // Key-Value Storage 값이 변경되었을때 호출된 핸들러 등록.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updateKeyValue:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:cloudKeyStore];
    
    [cloudKeyStore synchronize];
}


// iCloud Document Storage 초기화
- (void) setupDocumentCloud
{
    // 클라우드 API를 지원하지 안는 시스템이면 패스
    if (! IsSupportCloudAPI() ) return;

    // 클라우드 초기화
    if( ! [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] )
    {
        NSLog(@"It is not supported in iCloud Document Storage Service");
    }
         
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // load comic infos
    comicInfos = [[[Setting sharedSetting] comicInfos] retain];
    
    
    // 클라우드 API 초기화
    [self setupKeyValueCloud];
    [self setupDocumentCloud];

    // infos
    self.filelistViewController.comicInfos = comicInfos;
    
    // Override point for customization after application launch.

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

    [[Setting sharedSetting] setComicInfos:comicInfos];
    
    if (cloudKeyStore) {
        for (NSString *filename in comicInfos)
        {
            ComicInfo *info = [comicInfos objectForKey:filename];
                
            // last page가 변경된 경우에만 반영.
            NSNumber *cloudedPage = [cloudKeyStore objectForKey:filename];
            if ([cloudedPage integerValue] != info.lastPage ) {
                [cloudKeyStore setObject:[NSNumber numberWithInteger:info.lastPage] forKey:filename];
            }
            
        }
        
        [cloudKeyStore synchronize];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSMutableDictionary *comicInfos = self.filelistViewController.comicInfos;

    if (cloudKeyStore) {
        for (NSString *filename in comicInfos)
        {
            NSNumber *lastpage = [cloudKeyStore objectForKey:filename];
            if (lastpage)
            {
                ComicInfo *info = [comicInfos objectForKey:filename];
                info.lastPage = [lastpage integerValue];
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [comicInfos release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
