//
//  CPUInfo.h
//  myDeviceChecker
//
//  Created by  on 11. 9. 30..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPUInfo : NSObject
{
    double _load1min;
    double _load5mins;
    double _load15mins;
}

@property (nonatomic, readonly) double loadOf1Min;
@property (nonatomic, readonly) double loadOf5Mins;
@property (nonatomic, readonly) double loadOf15Mins;


- (void) update;

@end
