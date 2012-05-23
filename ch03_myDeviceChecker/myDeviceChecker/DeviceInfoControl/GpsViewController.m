//
//  GpsViewController.m
//  myDeviceChecker
//
//  Created by  on 11. 9. 19..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "GpsViewController.h"

@interface GpsViewController()

- (void) updateData;
- (void) updateValue:(NSString*)val forKey:(NSString *)key inDictionary:(NSMutableDictionary*) dic;

@end


@implementation GpsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_headers release];
    [_infos release];
    [_infoTitles release];
    [_gpsInfo stopMonitor];
    [_gpsInfo release];
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
    
    // table에 출력한 Data
    // table header string들.
    _headers = [[NSArray alloc] initWithObjects: 
                @"Location",
                @"Location accuracy",
                @"Digital Compass",
                @"Speed & Moving heading",
                nil];

    NSMutableDictionary *infoLocation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"", @"Latitude",
                                    @"", @"Longitude",
                                    @"Unknown", @"Altitude in meter",
                                    @"", @"Last update",
                                    nil];
    NSArray *infoLocationTitles = [[NSArray alloc]initWithObjects:@"Latitude",@"Longitude",@"Altitude in meter",@"Last update", nil];
    
    NSMutableDictionary *infoLocationAccuracy = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"", @"Horizontally",
                                    @"", @"Vertically",
                                    nil];

    NSArray *infoLocationAccuracyTitles = [[NSArray alloc]initWithObjects:@"Horizontally",@"Vertically", nil];
    
    NSMutableDictionary *infoCompass = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"", @"Magnetic North",
                                        @"", @"True North",
                                        @"", @"Accuracy",
                                    nil];
    NSArray *infoCompassTitles = [[NSArray alloc]initWithObjects:@"Magnetic North",@"True North",@"Accuracy", nil];

    NSMutableDictionary *infoSpeed = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"Unknown", @"m/s",
                                    @"Unknown", @"km/h",
                                    nil];
    NSArray *infoSpeedTitles = [[NSArray alloc]initWithObjects:@"m/s",@"km/h", nil];
    
    _infoTitles = [[NSArray alloc] initWithObjects:
                   infoLocationTitles,
                   infoLocationAccuracyTitles,
                   infoCompassTitles,
                   infoSpeedTitles,
                   nil];
    
    [infoSpeedTitles release];
    [infoCompassTitles release];
    [infoLocationAccuracyTitles release];
    [infoLocationTitles release];
    
    _infos = [[NSArray alloc] initWithObjects:
                       infoLocation,
                       infoLocationAccuracy,
                       infoCompass,
                       infoSpeed,
                       nil];
    
    [infoLocation release];
    [infoLocationAccuracy release];
    [infoCompass release];
    [infoSpeed release];
    
    [_gpsInfo = [GPSInfo alloc]init];
    _gpsInfo.delegate = self;
    [_gpsInfo startMonitor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_infos objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

    NSDictionary *info = [_infos objectAtIndex:indexPath.section];
    NSArray *keys = [_infoTitles objectAtIndex:indexPath.section];
    
    cell.textLabel.text = [keys objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [info objectForKey:[keys objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *info = [_infos objectAtIndex:section];
    if (info.count > 0) {
        return [_headers objectAtIndex:section];
    }
    return nil;
}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[GpsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    return [ret autorelease];
}

+ (UIImage*) iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"GPS";
}

+ (BOOL) isEnableDevice
{
    return YES;
}

#pragma mark - private apis

- (void) updateValue:(NSString*)val forKey:(NSString *)key inDictionary:(NSMutableDictionary*) dic
{
    if ([[dic objectForKey:key] isEqualToString: val]) {
        return;
    }
    [dic setObject:val forKey:key];

    NSInteger section = [_infos indexOfObject:dic];
    NSInteger row = [_infoTitles indexOfObject:key];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (void) updateData
{
    //
    // Location 
    //
    NSMutableDictionary *infoLocation = [_infos objectAtIndex:0];
    CLLocation *location = _gpsInfo.lastLocation;
    
    if ([_gpsInfo lastUpdateLocationOnSec] != -1) {
        [self updateValue:[NSString stringWithFormat:@"%.0f second ago",[_gpsInfo lastUpdateLocationOnSec]] forKey:@"Last update" inDictionary:infoLocation];
    }
    
    [self updateValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"Latitude" inDictionary:infoLocation];
    [self updateValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"Longitude" inDictionary:infoLocation];
    
    if (location.altitude > 0) {
        [self updateValue:[NSString stringWithFormat:@"%.1f",location.altitude] forKey:@"Altitude in meter" inDictionary:infoLocation];
    }
    
    //
    // location accuracy
    //
    NSMutableDictionary *infoLocationAccuracy = [_infos objectAtIndex:1];
    NSString *val = @"Unavailable";
    if (location.verticalAccuracy >= 0 ) {
        val = [NSString stringWithFormat:@"%.1f m", location.verticalAccuracy];
    }
    [self updateValue:val forKey:@"Vertically" inDictionary:infoLocationAccuracy];
    val = @"Unavailable";
    if (location.horizontalAccuracy >= 0 ) {
        val = [NSString stringWithFormat:@"%.0f m", location.horizontalAccuracy];
    }
    [self updateValue:val forKey:@"Horizontally" inDictionary:infoLocationAccuracy];

    // 
    // speed & moving heading
    //
    NSMutableDictionary *infoDistance = [_infos objectAtIndex:3];
    if (location.speed > 0) {
        [self updateValue:[NSString stringWithFormat:@".1f", location.speed] forKey:@"m/s" inDictionary:infoDistance];
        [self updateValue:[NSString stringWithFormat:@".1f", location.speed * 3.6] forKey:@"km/h" inDictionary:infoDistance];
    }

    //
    // compass
    //
    NSMutableDictionary *infoCompass = [_infos objectAtIndex:2];
    CLHeading *heading = _gpsInfo.lastHeading;
    [self updateValue:[NSString stringWithFormat:@"%.0f°",heading.magneticHeading] forKey:@"Magnetic North" inDictionary:infoCompass];
    [self updateValue:[NSString stringWithFormat:@"%.0f°",heading.trueHeading] forKey:@"True North" inDictionary:infoCompass];
    
    if (heading.headingAccuracy > 0) {
        [self updateValue:[NSString stringWithFormat:@"%.1f",heading.headingAccuracy] forKey:@"Accuracy" inDictionary:infoCompass];
    }
    
    

}

#pragma mark - GPSInfoDelegate

- (void) gpsInfoLocationUpdated:(GPSInfo*)info
{
    [self updateData];
}
- (void) gpsInfoHeadingUpdated:(GPSInfo*)info
{
    [self updateData];
}


@end
