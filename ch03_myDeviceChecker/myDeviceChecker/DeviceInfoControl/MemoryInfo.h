//
//  MemoryInfo.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryInfo : NSObject
{
    // 여유 메모리
    CGFloat freeMemory;
    // 사용된 메모리로 다른 app에 의해서 점유된 메모리
    CGFloat wiredMemory;
    // 활성 메모리
    CGFloat activeMemory;
    // 비활성 메모리, 언제든지 다른 용도로 활용될 수 있는 메모리
    CGFloat inactiveMemory;    
}
@property (nonatomic, readonly) CGFloat freeMemory;
@property (nonatomic, readonly) CGFloat wiredMemory;
@property (nonatomic, readonly) CGFloat activeMemory;
@property (nonatomic, readonly) CGFloat inactiveMemory;

// 사용중인 메모리 ( free 메모리를 제외한 메모리 )
- (CGFloat) usedMemory;
// 총 메모리 ( 4종류의 메모리를 합친 메모리량 )
- (CGFloat) totalMemory;
// 총메모리 ( 비디오 메모리를 제외한 )
- (CGFloat) phisicalMemory;
// 유저 메모리
- (CGFloat) userMemory;
// 커널 메모리
- (CGFloat) kernelMemory;
// 메모리 정보를 업데이트한다.
- (void) update;
@end
