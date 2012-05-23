//
//  GeneralInfoViewController.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"

@interface GeneralInfoViewController : UITableViewController <DeviceViewItem>
{
    @private
    NSArray *_infos;
    NSArray *_headerOfInfos;
}
@end
