//
//  DeviceInfo.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 8..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "DeviceInfo.h"
#include <mach/mach_time.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation DeviceInfo

@synthesize sysName = _sysName;
@synthesize sysVersion = _sysVersion;
@synthesize uuid = _uuid;
@synthesize phone = _phone;
@synthesize model = _model;
@synthesize owner = _owner;
@synthesize imei = _imei;
@synthesize mainScreenSize = _mainScreenSize;
@synthesize statusbarSize = _statusbarSize;
@synthesize orientationString = _orientationString;
@synthesize orientation = _orientation;

- (NSString*) sysName
{
    return [[UIDevice currentDevice] systemVersion]; 
    
}

- (NSString*) sysVersion
{
    return [[UIDevice currentDevice] systemName]; 
    
}

- (NSString*) uuid
{
    return [[UIDevice currentDevice] uniqueIdentifier]; 
    
}

- (NSString*) owner
{
    return [[UIDevice currentDevice] name]; 
}

- (NSString*) imei
{
    NSString *imei = nil;
    //    // private api로 imei 정보를 구한다.
    //    imei = [device imei];
    //    if(!imei)
    //        imei = @"iOS NOT Support";
    //    imei = imei;
    return imei;
}

- (CGSize) mainScreenSize
{
    return [[UIScreen mainScreen] bounds].size;
}

- (CGSize) statusbarSize
{
    return [[UIScreen mainScreen] bounds].size;
}

- (NSString*) orientationString
{
    UIDevice *device = [UIDevice currentDevice]; 
    UIDeviceOrientation orientation = [device orientation];
    NSString *orientationString = @"UIDeviceOrientationUnknown";
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            orientationString = @"UIDeviceOrientationPortrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationString = @"UIDeviceOrientationPortraitUpsideDown";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationString = @"UIDeviceOrientationLandscapeLeft";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationString = @"UIDeviceOrientationLandscapeRight";
            break;
        case UIDeviceOrientationFaceUp:
            orientationString = @"UIDeviceOrientationFaceUp";
            break;
        case UIDeviceOrientationFaceDown:
            orientationString = @"UIDeviceOrientationFaceDown";
            break;
        default:
            orientationString = @"UIDeviceOrientationUnknown";
            break;
    }
    
    
    return orientationString;
}

- (NSDate*) bootTime
{
    static const int64_t kOneMillion = 1000 * 1000;
    static mach_timebase_info_data_t s_timebase_info;
    
    if (s_timebase_info.denom == 0) {
        (void) mach_timebase_info(&s_timebase_info);
    }
    
    // mach_absolute_time() returns billionth of seconds,
    // so divide by one million to get milliseconds
    int uptimeInMillisec = (int)((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom));

    
    NSDate *lastRebootTime = [[NSDate date] addTimeInterval:-(uptimeInMillisec / 1000.0f)];
    return lastRebootTime;
}

- (NSString*) model
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

@end
