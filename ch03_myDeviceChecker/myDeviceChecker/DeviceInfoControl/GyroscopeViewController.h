//
//  GyroscopeViewController.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 9. 14..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewItem.h"
#import "CorePlot-CocoaTouch.h"

@class CMMotionManager;
@class CMAttitude;

@interface GyroscopeViewController : UIViewController 
<DeviceViewItem, CPTPlotDataSource>
{
@private
    CMMotionManager *_motionManager;

    UILabel *_gyroRoll;
    UILabel *_gyroPitch;
    UILabel *_gyroYaw;
    
    CPTGraphHostingView  *_graphHostingView;
    NSMutableArray *_plotDataForPosition;
    NSInteger _currentIndex;

}
@property (nonatomic, retain) IBOutlet CPTGraphHostingView  *graphHostingView;

@property(nonatomic,retain) IBOutlet UILabel *gyroRoll;
@property(nonatomic,retain) IBOutlet UILabel *gyroPitch;
@property(nonatomic,retain) IBOutlet UILabel *gyroYaw;

@end
