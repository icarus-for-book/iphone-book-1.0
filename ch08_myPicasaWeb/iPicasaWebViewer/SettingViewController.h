//
//  SettingViewController.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionViewController.h"

@class Setting;

@interface SettingViewController : UITableViewController<OptionViewControllerDelegate> {

    Setting *setting;
    
}

@end
