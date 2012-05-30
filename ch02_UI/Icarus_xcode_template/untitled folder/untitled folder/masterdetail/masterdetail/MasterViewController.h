//
//  MasterViewController.h
//  masterdetail
//
//  Created by parkinhye on 11. 12. 12..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

//Added by cosmos
@property (strong, nonatomic) DetailViewController *mainDetailViewController;

@end
