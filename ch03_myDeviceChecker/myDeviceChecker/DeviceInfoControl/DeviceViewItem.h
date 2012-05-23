//
//  DeviceViewItem.h
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DeviceViewItem <NSObject>
// view controller 생성
+ (id) createViewItem;
// list에 표시할 icon image
+ (UIImage*)   iconImage;
// list에 표시할 title
+ (NSString*)  title;
// 테스트 하려는 기능이 현재 Device에서 동작하는지 확인하는 메소드
+ (BOOL) isEnableDevice;
@end
