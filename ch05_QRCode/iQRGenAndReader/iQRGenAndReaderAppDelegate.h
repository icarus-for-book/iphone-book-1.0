//
//  iQRGenAndReaderAppDelegate.h
//  iQRGenAndReader
//
//  Created by parkinhye on 11. 6. 19..
//  Copyright 2011 sss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iQRGenAndReaderViewController;

@interface iQRGenAndReaderAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iQRGenAndReaderViewController *viewController;

@end
