//
//  guguquizAppDelegate.h
//  guguquiz
//
//  Created by Jinsub Ahn on 11. 11. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface guguquizAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabController;

@end
