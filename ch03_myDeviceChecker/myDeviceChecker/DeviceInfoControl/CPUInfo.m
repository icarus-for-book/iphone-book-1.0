//
//  CPUInfo.m
//  myDeviceChecker
//
//  Created by  on 11. 9. 30..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "CPUInfo.h"

@implementation CPUInfo

@synthesize loadOf1Min = _load1min;
@synthesize loadOf5Mins = _load5mins;
@synthesize loadOf15Mins = _load15mins;

- (id)init
{
    self = [super init];
    if (self) {
        [self update];
    }
    
    return self;
}

- (void) update
{
    double la[3];
    getloadavg(la, 3);
    NSLog(@"%f - %f - %f", la[0], la[1], la[2]);
    
    _load1min = la[0];
    _load5mins = la[1];
    _load15mins = la[2];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f - %f - %f", _load1min, _load5mins, _load15mins];
    
}
@end
