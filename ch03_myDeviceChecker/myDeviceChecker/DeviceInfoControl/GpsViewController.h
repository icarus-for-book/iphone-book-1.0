//
//  GpsViewController.h
//  myDeviceChecker
//
//  Created by  on 11. 9. 19..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSInfo.h"

@interface GpsViewController : UITableViewController < GPSInfoDelegate >
{
    // GPS 정보
    GPSInfo *_gpsInfo;
    // table에 출력한 Data
    NSArray *_infos;
    // infos의 출력할 Data 순서
    NSArray *_infoTitles;
    // table header string들.
    NSArray *_headers;
}

@end
