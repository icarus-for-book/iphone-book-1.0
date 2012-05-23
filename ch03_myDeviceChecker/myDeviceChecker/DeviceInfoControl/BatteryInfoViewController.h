//
//  BatteryViewController.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"

@class BatteryInfo;

@interface BatteryInfoViewController : UIViewController <DeviceViewItem> {
    @private    
    UILabel *_labelLevel;
    BatteryInfo* _batteryInfo;
    UIImageView *_imageBattery;
    UIImageView *_imageCharging;
}

@property (nonatomic, retain) IBOutlet UILabel *labelLevel;
@property (nonatomic, retain) IBOutlet UIImageView *imageBattery;
@property (nonatomic, retain) IBOutlet UIImageView *imageCharging;

@end
