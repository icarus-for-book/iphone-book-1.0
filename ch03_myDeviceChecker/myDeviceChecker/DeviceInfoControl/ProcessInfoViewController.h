//
//  ProcessInfoViewController.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"
#import "ProcessInfo.h"
#import "ProcessInfoCell.h"

@interface ProcessInfoViewController : UIViewController <DeviceViewItem>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet ProcessInfoCell *cell;
@property (nonatomic, retain) id cellNib;

@end
