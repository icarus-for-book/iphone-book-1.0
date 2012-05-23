//
//  MemoryInfo.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "MemoryInfo.h"
#import <sys/sysctl.h>
#import <mach/mach.h> 
#import <mach/mach_host.h>



@implementation MemoryInfo

@synthesize freeMemory;
@synthesize wiredMemory;
@synthesize activeMemory;
@synthesize inactiveMemory;

- (id) init
{
    self = [super init];
    if (self)
    {
        [self update];
    }
    return self;
}

// 사용중인 메모리 ( Free 메모리를 제외한 )
- (CGFloat) usedMemory
{
    return wiredMemory + activeMemory + inactiveMemory;
}
// 총 메모리.
- (CGFloat) totalMemory
{
    return freeMemory + [self usedMemory];
}

// 메모리 업데이트
- (void) update
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    // page size 구하기 ( 보통 iOS, Mac은 4KB이다.)
    host_page_size(host_port, &pagesize);
    
    kern_return_t stat_ret = host_statistics(host_port, 
                                             HOST_VM_INFO, 
                                             (host_info_t)&vm_stat, 
                                             &host_size);
    if (stat_ret != KERN_SUCCESS) 
        NSLog(@"Failed to fetch vm statistics");
    
    // Data를 계산한다.
    inactiveMemory = vm_stat.inactive_count * pagesize;
    activeMemory = vm_stat.active_count * pagesize;
    wiredMemory = vm_stat.wire_count * pagesize;
    freeMemory = vm_stat.free_count * pagesize;
}

// 비디오 메모리를 제외한 주메모리 용량
- (CGFloat) phisicalMemory
{
    int mem;
    int mib[2];
    mib[0] = CTL_HW;
    mib[1] = HW_PHYSMEM;
    size_t length = sizeof(mem);
    sysctl(mib, 2, &mem, &length, NULL, 0);
    
    return mem;
}

// 사용자 메모리
- (CGFloat) userMemory
{
    int mem;
    int mib[2];
    mib[0] = CTL_HW;
    mib[1] = HW_USERMEM;
    size_t length = sizeof(mem);
    sysctl(mib, 2, &mem, &length, NULL, 0);
    
    return mem;
}

// 커널 메모리
- (CGFloat) kernelMemory 
{
    return [self phisicalMemory] - [self userMemory];
}




@end
