//
//  BatteryInfo.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 8..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "BatteryInfo.h"


@implementation BatteryInfo

- (id)init
{
    self = [super init];
    if (self) {
        // batter status를 추적한다.
        // 이 값이 NO로 되어 있으면 batterState가 UIDeviceBatteryStateUnknow으로 보인다.
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    }
    
    return self;
}

- (void) dealloc
{
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    [super dealloc];
}

// IOKit framework이 없으므로 필요한 header를 복사해서
// import 시킴.
//#import <IOKit/ps/IOPowerSources.h>
//#import <IOKit/ps/IOPSKeys.h>
#import "IOPowerSources.h"
#import "IOPSKeys.h"

- (CGFloat)levelInDetail
{
    
#if 0
    // 이 기능을 사용하기 위해서 libIOKit.dylib를 추가해야 한다.
    
    // UIDevice에서 가져오는 battery level은 정확도가 0.05단위이다.
    // 즉, 80%,83% 모두 0.8로 표시된다.
    //return [UIDevice currentDevice].batteryLevel;

    // 아래 방법은 직접 battery level을 구하는 방식이다. 이 방식은 Mac OS X의 
    // 방식이다. 하지만 이 방식을 쓰기 위해서는 IOKit framework의 해더가 필요하다.
    // 이 방식을 쓰기 위해서 
    //
    // - Mac OS X의 IOKit의 IOPowerSources.h, IOPSKeys.h를 복사해서 import 시킴.
    // - libIOKit.dylib를 link에 포함.
    //
    // @ref http://lists.omnipotent.net/pipermail/lcdproc/2006-January/010417.html
    // @ref http://forums.macrumors.com/showthread.php?t=474628
    
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    
    CGFloat ret = -1.0f;
    
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    
    int numOfSources = CFArrayGetCount(sources);    
    for (int i = 0 ; i < numOfSources ; i++)
    {
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource) {
            ret = -1.0f;
            break;
        }

        int curCapacity = 0;
        int maxCapacity = 0;
        double level;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        
        level =  (double)curCapacity/(double)maxCapacity;
        
        ret = level;
        break;
    }
    
    CFRelease(sources);
    CFRelease(blob);
    
    return ret;
#else
    return -1;
#endif
}

- (CGFloat)level
{
    CGFloat ret = [UIDevice currentDevice].batteryLevel;
    return ret;
}

- (UIDeviceBatteryState)state
{
    return [UIDevice currentDevice].batteryState;
}



@end
