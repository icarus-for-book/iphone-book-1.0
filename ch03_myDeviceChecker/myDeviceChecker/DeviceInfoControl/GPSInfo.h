//
//  GPSInfo.h
//  myDeviceChecker
//
//  Created by  on 11. 9. 19..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class GPSInfo;

@protocol GPSInfoDelegate <NSObject>
- (void) gpsInfoLocationUpdated:(GPSInfo*)info;
- (void) gpsInfoHeadingUpdated:(GPSInfo*)info;
@end

// GPS Inforamtaion
@interface GPSInfo : NSObject < CLLocationManagerDelegate >
{
    @private
    // location manager for GPS
    CLLocationManager *_locationManager;
    // delegate
    id <GPSInfoDelegate> _delegate;
    // flag for staring monitor
    BOOL _isStartingMonitor;
    
    // 이전 Heading 정보
    CLHeading *_prevHeading;
    // 최근 Heading 정보
    CLHeading *_lastHeading;
    // 이전 Location 정보 
    CLLocation *_prevLocation;
    // 최근 Location 정보
    CLLocation *_lastLocation;
}

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, assign) id <GPSInfoDelegate> delegate;

// 이전 Heading 정보
@property(nonatomic, retain) CLHeading *prevHeading;
// 최근 Heading 정보
@property(nonatomic, retain) CLHeading *lastHeading;
// 이전 Location 정보 
@property(nonatomic, retain) CLLocation *prevLocation;
// 최근 Location 정보
@property(nonatomic, retain) CLLocation *lastLocation;


- (void) startMonitor;
- (void) stopMonitor;

// location update 시간을 초단위로 환산해서 return 
- (NSTimeInterval) lastUpdateLocationOnSec;
// heading update 시간을 초단위로 환산해서 return 

- (NSTimeInterval) lastUpdateHeadingOnSec;

@end
