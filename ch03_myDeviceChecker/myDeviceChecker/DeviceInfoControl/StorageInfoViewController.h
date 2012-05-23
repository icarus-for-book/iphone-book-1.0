//
//  StorageInfoViewController.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"
#import "PieChart.h"
#import "CorePlot-CocoaTouch.h"

@interface StorageInfoViewController : UIViewController 
< DeviceViewItem, CPTPlotDataSource > 
{
    UILabel *totalSize;
    UILabel *usedSize;
    UILabel *freeSize;
    
    CPTXYGraph *_chart;
    CPTGraphHostingView *_graphHostingView;
}

@property (nonatomic, retain) IBOutlet UILabel *totalSize;
@property (nonatomic, retain) IBOutlet UILabel *usedSize;
@property (nonatomic, retain) IBOutlet UILabel *freeSize;
@property (nonatomic, retain) IBOutlet CPTGraphHostingView *graphHostingView;



@end
