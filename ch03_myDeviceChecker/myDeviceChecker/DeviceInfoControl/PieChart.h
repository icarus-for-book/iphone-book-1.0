//
//  PieChart.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 9. 15..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PieChart : UIView
{
    @private
    NSMutableArray *_datas;
}

// data 추가 
- (void) addPercent:(CGFloat)percent color:(UIColor*)color;
// data 초기화 
- (void)clearData;

@end
