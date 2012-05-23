//
//  NetworkInfo.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 11..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

// Network 정보 조회를 위한 클래스
@interface NetworkInfo : NSObject
{
    Reachability *_reachablilityForInternet;
    Reachability *_reachablilityForLocalWifi;
}

@property (nonatomic, readonly, getter = isConnected) BOOL connected;
@property (nonatomic, readonly) NSString *macAddress;
// wifi 연결 ip address
@property (nonatomic, readonly) NSString *wifiAddress;
// cell 연결 ip address
@property (nonatomic, readonly) NSString *cellAddress;


// update network information
- (void) update;

@end
