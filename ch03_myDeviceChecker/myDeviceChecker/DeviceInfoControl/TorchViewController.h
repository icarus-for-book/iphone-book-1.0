//
//  TorchViewController.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 9. 14..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"

@class AVCaptureSession;

@interface TorchViewController : UIViewController <DeviceViewItem>
{

    // AVCapture Session
    AVCaptureSession *_avSession;
    // tourch가 켜져 있는지 
    BOOL              _torchOn;
    
}

@property (nonatomic, retain) AVCaptureSession *avSession;

- (IBAction)onToggleTorch:(id)sender;

@end
