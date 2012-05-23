//
//  SettingViewController.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionViewController.h"


// 설정화면으로 Application에서 사용될 설정값을 사용자가 선택할 수 있는 
// UI를 제공한다.
@interface SettingViewController : UITableViewController <OptionViewControllerDelegate>

@end
