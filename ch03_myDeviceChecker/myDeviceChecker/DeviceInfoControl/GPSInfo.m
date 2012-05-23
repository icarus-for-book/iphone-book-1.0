//
//  GPSInfo.m
//  myDeviceChecker
//
//  Created by  on 11. 9. 19..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "GPSInfo.h"

@implementation GPSInfo

@synthesize locationManager = _locationManager;
@synthesize delegate = _delegate;
@synthesize prevHeading = _prevHeading;
@synthesize lastHeading = _lastHeading;
@synthesize prevLocation = _prevLocation;
@synthesize lastLocation = _lastLocation;



- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDelegate:self];
    }
    
    return self;
}

- (void) dealloc
{
    [self stopMonitor];
    [_locationManager release];
    [_prevHeading release];
    [_lastHeading release];
    [_prevLocation release];
    [_lastLocation release];
    [super dealloc];
}

- (void) startMonitor
{
    if (_isStartingMonitor) {
        return;
    }
    _isStartingMonitor = YES;
    [_locationManager startUpdatingHeading];
    [_locationManager startUpdatingLocation];
}

- (void) stopMonitor
{
    if (!_isStartingMonitor) {
        return;
    }
    _isStartingMonitor = NO;
    [_locationManager stopUpdatingHeading];
    [_locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    self.prevHeading = self.lastHeading;
    self.lastHeading = newHeading;
    
    if (_delegate && [_delegate respondsToSelector:@selector(gpsInfoHeadingUpdated:)]) 
    {
        [_delegate gpsInfoHeadingUpdated:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.prevLocation = self.lastLocation;
    self.lastLocation = newLocation;

    if (_delegate && [_delegate respondsToSelector:@selector(gpsInfoLocationUpdated:)])
    {
        [_delegate gpsInfoLocationUpdated:self];
    }
}

- (NSTimeInterval) lastUpdateLocationOnSec
{
    if (self.prevLocation != nil) {
        return [self.lastLocation.timestamp timeIntervalSinceDate:self.prevLocation.timestamp];
    }
    
    return -1;
}

- (NSTimeInterval) lastUpdateHeadingOnSec
{
    if (self.prevLocation != nil) {
        return [self.lastHeading.timestamp timeIntervalSinceDate:self.prevHeading.timestamp];
    }
    
    return -1;
}
@end
