//
//  NerworkInfoViewController.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"
#import "NetworkInfo.h"

@interface NetworkInfoViewController : UITableViewController <DeviceViewItem> {
    NetworkInfo *networkInfo;
    NSArray *_infos;
}

@end
