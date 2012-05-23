//
//  icomicviewerAppDelegate.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilelistViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

    NSMutableDictionary* comicInfos;
    FilelistViewController* filelistViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *viewController;

@property (nonatomic, retain) IBOutlet FilelistViewController* filelistViewController;

@end
