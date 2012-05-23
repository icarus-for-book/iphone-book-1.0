//
//  CompassViewController.m
//  myDeviceChecker
//
//  Created by 진섭 안 on 11. 9. 16..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "CompassViewController.h"

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@interface CompassViewController()

// compass 초기화 
- (void) initCompass;

@end

@implementation CompassViewController

@synthesize locationManager = _locationManager;
@synthesize compass=_compass;
@synthesize labelHeading = _labelHeading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initCompass];
        _headingType = COMPASS_MAGNETIC;
    }
    return self;
}

- (void) dealloc
{
    [_labelHeading release];
    [_compass release];
    if (self.locationManager) {
        [self.locationManager stopUpdatingHeading];
    }
    [_locationManager release];
    [super dealloc];
}


#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[CompassViewController alloc] initWithNibName:@"CompassViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*) iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Compass";
}

+ (BOOL) isEnableDevice
{
    return YES;
}

#pragma mark - event handler
- (IBAction)onClickCompassType:(id)sender
{
    UISegmentedControl *seg = sender;
    if ( seg.selectedSegmentIndex == 0 )
    {
        // 자북.
        _headingType = COMPASS_MAGNETIC;
    } else 
    {
        // 진북.
        _headingType = COMPASS_TRUE;
    }
}

#pragma mark - CCLocationManagerDelegate handler
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    CGFloat heading = _headingType == COMPASS_TRUE ?
                        newHeading.magneticHeading :
                        newHeading.trueHeading;

    self.labelHeading.text = [NSString stringWithFormat:@"%d°", (int)heading];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve: UIViewAnimationCurveLinear];
    self.compass.transform = CGAffineTransformMakeRotation(radians(- (int)heading));
    [UIView commitAnimations];
}

#pragma mark - private method

- (void) initCompass
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingHeading];
    
    self.locationManager = locationManager;
    

}

@end
