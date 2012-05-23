//
//  iQRGenAndReaderViewController.h
//  iQRGenAndReader
//
//  Created by parkinhye on 11. 6. 19..
//  Copyright 2011 sss. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iQRGenViewController.h"
#import "iQRReaderViewController.h"

#import "ZBarSDK.h"

@interface iQRGenAndReaderViewController : UIViewController <ZBarReaderDelegate> {
    iQRGenViewController *qrGenViewController;
    iQRReaderViewController *qrReaderViewController;
}

@property(nonatomic, retain) iQRGenViewController *qrGenViewController;
@property(nonatomic, retain) iQRReaderViewController *qrReaderViewController;

@end
