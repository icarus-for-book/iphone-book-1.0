//
//  BatteryViewController.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "BatteryInfoViewController.h"
#import "BatteryInfo.h"

@interface BatteryInfoViewController()

@property (nonatomic, retain) NSTimer *updateTimer;

// update battery infomation
- (void) updateInfo;
- (void) registerUpdateTimer;
- (void) unregisterUpdateTimer;

// 백버튼을 눌렸을때의 호출되는 함수.
- (void) onClickBackButton;

@end


@implementation BatteryInfoViewController
@synthesize labelLevel=_labelLevel;
@synthesize imageBattery=_imageBattery;
@synthesize imageCharging=_imageCharging;
@synthesize updateTimer=_updateTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _batteryInfo = [[BatteryInfo alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_updateTimer release];
    [_imageCharging release];
    [_imageBattery release];
    [_batteryInfo release];
    [_labelLevel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageCharging.animationImages =
            [NSArray arrayWithObjects:
             [UIImage imageNamed:@"charging01.png"],
             [UIImage imageNamed:@"charging02.png"],
             [UIImage imageNamed:@"charging03.png"],
             [UIImage imageNamed:@"charging04.png"],
             [UIImage imageNamed:@"charging05.png"],
             [UIImage imageNamed:@"charging06.png"],
             [UIImage imageNamed:@"charging07.png"],
             [UIImage imageNamed:@"charging08.png"],
             [UIImage imageNamed:@"charging09.png"],
             [UIImage imageNamed:@"charging10.png"],
             [UIImage imageNamed:@"charging11.png"],
             [UIImage imageNamed:@"charging12.png"],
             nil];
    self.imageCharging.animationDuration = 1.0f;
    self.imageCharging.animationRepeatCount = 0;
}

- (void)viewDidUnload
{
    [self setLabelLevel:nil];
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerUpdateTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self unregisterUpdateTimer];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) updateInfo
{
    int label = abs(_batteryInfo.level * 100.0f);
    self.labelLevel.text = [NSString stringWithFormat:@"%d %%", label];
    
    if (label == 100) {
        self.imageBattery.image = [UIImage imageNamed:@"battery5.png"];
    } else if( label >= 80 ) { 
        self.imageBattery.image = [UIImage imageNamed:@"battery4.png"];
    } else if( label >= 60 ) {
        self.imageBattery.image = [UIImage imageNamed:@"battery3.png"];
    } else if( label >= 40 ) {
        self.imageBattery.image = [UIImage imageNamed:@"battery2.png"];
    } else {
        self.imageBattery.image = [UIImage imageNamed:@"battery1.png"];
    }
    
    UIDeviceBatteryState status = _batteryInfo.state;
    switch (status) {
        case UIDeviceBatteryStateCharging:
            if( ! [self.imageCharging isAnimating] )
            {
                self.imageCharging.hidden = NO;
                [self.imageCharging startAnimating];
            }
            break;
        case UIDeviceBatteryStateFull:
        case UIDeviceBatteryStateUnplugged:
        case UIDeviceBatteryStateUnknown:
            self.imageCharging.hidden = YES;
            [self.imageCharging stopAnimating];
            break;

    }
}

- (void) registerUpdateTimer
{
    [self.updateTimer invalidate];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    [self updateInfo];
}

- (void) unregisterUpdateTimer
{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void) onClickBackButton
{
    [self unregisterUpdateTimer];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[BatteryInfoViewController alloc] initWithNibName:@"BatteryInfoViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*)   iconImage
{
    return [UIImage imageNamed:@"battery.png"];
}

+ (NSString*)  title
{
    return @"battery";
}

+ (BOOL) isEnableDevice
{
    return YES;
}


@end
