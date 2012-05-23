//
//  GyroPositionDataSource.h
//  myDeviceChecker
//
//  Created by  on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface GyroPositionDataSource : NSObject <CPTPlotDataSource>
{
    NSMutableArray *_datas;
}

- (void) addDataRoll:(CGFloat)roll pitch:(CGFloat)pitch yaw:(CGFloat)yaw;

@end
