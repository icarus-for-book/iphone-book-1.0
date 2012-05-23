//
//  ProcessInfo.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 11..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "ProcessInfo.h"
#import <sys/sysctl.h>

@implementation ProcessInfo

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSArray *)runningProcesses 
{
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    // 필요한 메모리 구하기
    size_t size;
    int st = 0;
    
    sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;

    // process list data 가져오기
    do {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess){
            if (process){
                free(process);
            }
            return nil;
        }
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    // 가져온 process 정보에서 id, name을 구한다. 
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                
                for (int i = nprocess - 1; i >= 0; i--){
                    
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil] 
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
                    [processID release];
                    [processName release];
                    [array addObject:dict];
                    [dict release];
                }
                
                free(process);
                return [array autorelease];
            }
        }
    }
    return nil;
}
@end
