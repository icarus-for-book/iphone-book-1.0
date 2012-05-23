//
//  GyroPositionDataSource.m
//  myDeviceChecker
//
//  Created by  on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "GyroPositionDataSource.h"

@implementation GyroPositionDataSource

- (id)init
{
    self = [super init];
    if (self) {
        _datas = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}

- (void) dealloc
{
    [_datas release];
    [super dealloc];
}

- (void) addDataRoll:(CGFloat)roll pitch:(CGFloat)pitch yaw:(CGFloat)yaw
{
    
}


@end
