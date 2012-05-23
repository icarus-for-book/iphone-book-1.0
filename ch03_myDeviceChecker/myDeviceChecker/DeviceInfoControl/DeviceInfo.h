//
//  DeviceInfo.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 8..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 디바디스의 일반 정보들에 대한 정보
@interface DeviceInfo : NSObject

// firmware name
@property(nonatomic, readonly) NSString *sysName;
// firmware version
@property(nonatomic, readonly) NSString *sysVersion;
// 단말을 식별하기 위한 UUID
@property(nonatomic, readonly) NSString *uuid;
// 전화번호 정보 
@property(nonatomic, readonly) NSString *phone;
// 기기 모델 정보
@property(nonatomic, readonly) NSString *model;
// 소요자 정보
@property(nonatomic, readonly) NSString *owner;
// imei 정보를 관리 대상으로 app store의 reject 사유가 될 수 있습니다.
@property(nonatomic, readonly) NSString *imei;
// screen size
@property(nonatomic, readonly) CGSize    mainScreenSize;
// 화면 상단의 statusbar size
@property(nonatomic, readonly) CGSize    statusbarSize;
// orientation을 문자열로 나타낸 값.
@property(nonatomic, readonly) NSString *orientationString;
// orientation
@property(nonatomic, readonly) UIDeviceOrientation orientation;
// Booting 
@property(nonatomic, readonly) NSDate *bootTime;

@end
