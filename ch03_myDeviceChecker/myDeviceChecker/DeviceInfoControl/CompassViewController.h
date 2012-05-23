//
//  CompassViewController.h
//  myDeviceChecker
//
//  Created by 진섭 안 on 11. 9. 16..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DeviceViewItem.h"

typedef enum {
    COMPASS_TRUE,       // 진북 
    COMPASS_MAGNETIC,   // 자북
} CompassHeadingType;

@interface CompassViewController : UIViewController < DeviceViewItem, CLLocationManagerDelegate >
{
    CLLocationManager *_locationManager;
    UIImageView *_compass;
    UILabel *_labelHeading;             
    CompassHeadingType _headingType;   // 진북 or 자북
}

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) IBOutlet UIImageView *compass;
@property(nonatomic, retain) IBOutlet UILabel *labelHeading;

// compass type 변경할때.
- (IBAction)onClickCompassType:(id)sender;



@end
