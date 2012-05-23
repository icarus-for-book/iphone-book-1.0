//
//  StorageInfo.h
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 8..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageInfo : NSObject
{
    unsigned long long _usedSize;
    unsigned long long _freeSize;
}

// 사용된 store 용량
@property(nonatomic, assign) unsigned long long usedSize;
// 남은 store 용량
@property(nonatomic, assign) unsigned long long freeSize;
// 총 storage 용량 
@property(nonatomic, readonly) unsigned long long totalSize;
// iPod의 노래 갯수
@property(nonatomic, readonly) NSUInteger countOfSongs;


// 정보를 다시 조회
- (void) update;


@end
