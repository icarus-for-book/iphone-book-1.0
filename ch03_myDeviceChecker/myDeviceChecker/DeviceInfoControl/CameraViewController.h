//
//  CameraViewController.h
//  myDeviceChecker
//
//  Created by 진섭 안 on 11. 9. 18..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController;

@interface CameraViewController : UIViewController < UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *_imageView;
    OverlayViewController *_overlay;
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView;

-(IBAction) onTakePicture;

@end
