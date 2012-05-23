//
//  MemoryInfoViewController.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"

@class MemoryInfo;
@class PieChart;

// 메모리 정보를 화면에 표시하는 뷰컨트롤러
@interface MemoryInfoViewController : UIViewController 
< DeviceViewItem, UINavigationBarDelegate > 
{
    UILabel *_wiredSize;
    UILabel *_wiredPercent;
    UILabel *_activePercent;
    UILabel *_inactiveSize;
    UILabel *_inactivePercent;
    UILabel *_freeSize;
    UILabel *_freePercent;
    UILabel *_totalSize;
    UILabel *_usedSize;
    UILabel *_freeBriefSize;
    UILabel *_activeSize;
    
    // 메모리 정보 조회를 위한 객체
    MemoryInfo *_memoryInfo;
    // 파이챠트 뷰
    PieChart *_pieChart;
}

@property (nonatomic, retain) IBOutlet UILabel *wiredPercent;
@property (nonatomic, retain) IBOutlet UILabel *activePercent;
@property (nonatomic, retain) IBOutlet UILabel *inactivePercent;
@property (nonatomic, retain) IBOutlet UILabel *freePercent;

@property (nonatomic, retain) IBOutlet UILabel *activeSize;
@property (nonatomic, retain) IBOutlet UILabel *wiredSize;
@property (nonatomic, retain) IBOutlet UILabel *inactiveSize;
@property (nonatomic, retain) IBOutlet UILabel *freeSize;

@property (nonatomic, retain) IBOutlet UILabel *totalSize;
@property (nonatomic, retain) IBOutlet UILabel *usedSize;
@property (nonatomic, retain) IBOutlet UILabel *freeBriefSize;

@property (nonatomic, retain) IBOutlet PieChart *pieChart;

@end
