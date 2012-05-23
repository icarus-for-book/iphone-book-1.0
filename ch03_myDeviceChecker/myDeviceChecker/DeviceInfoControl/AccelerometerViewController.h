//
//  AccelerometerViewController.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 9. 14..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface AccelerometerViewController : UIViewController <UIAccelerometerDelegate>
{
    @private
    // acceleremeter manager
    UIAccelerometer *_accelerometer;

    //
    // VIEW
    //
    UILabel *_labelX;
    UILabel *_labelY;
    UILabel *_labelZ;
    
    // chart를 그리기 위한 view
    CPTGraphHostingView  *_graphHostingView;
    // chart에 쓰인 데이터
    NSMutableArray *_plotData;
    // 현재 보여줄 index ( 이 값을 이용해서 chart 좌표를 변경한다. )
    NSInteger _currentIndex;

}

@property (nonatomic, retain) IBOutlet CPTGraphHostingView  *graphHostingView;
@property (nonatomic, retain) IBOutlet UILabel *labelX;
@property (nonatomic, retain) IBOutlet UILabel *labelY;
@property (nonatomic, retain) IBOutlet UILabel *labelZ;

@end
