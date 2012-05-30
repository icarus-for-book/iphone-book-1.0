//
//  PageBasedMasterViewController.h
//  new
//
//  Created by parkinhye on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageBasedDetailViewController;

@interface PageBasedMasterViewController : UITableViewController

@property (strong, nonatomic) PageBasedDetailViewController *detailViewController;

@end
