//
//  RootViewController.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"

@interface MainViewController : UITableViewController
{
    // system infomation viewcontrollers
    NSArray *_deviceInfoViewControllers;
    // device check viewcontrollers
    NSArray *_deviceCtrlViewControllers;
    
}

@property (nonatomic, retain) NSArray *deviceInfoViewControllers;
@property (nonatomic, retain) NSArray *deviceCtrlViewControllers;

@end
