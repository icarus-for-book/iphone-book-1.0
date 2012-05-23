//
//  BatteryInfo.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 8..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 배터리의 정보를 조회하는 클래스
@interface BatteryInfo : NSObject

// 배터리량을 반환한다. ( 1.0이면 100% 충전상태를 의미한다.)
@property(nonatomic, readonly) CGFloat level;
// 배터리의 전체 용량에서 현재용량의 비를 반환한다. ( 1.0이면 100% 충전상태를 의미한다.)
@property(nonatomic, readonly) CGFloat levelInDetail;
// 배터리의 충전 상태를 반환한다.
@property(nonatomic, readonly) UIDeviceBatteryState state;

@end
