//
//  DetailViewController.h
//  masterdetailapp
//
//  Created by parkinhye on 11. 11. 30..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
