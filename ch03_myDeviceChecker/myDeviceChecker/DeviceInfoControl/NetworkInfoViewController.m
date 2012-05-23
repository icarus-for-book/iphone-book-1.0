//
//  NerworkInfoViewController.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "NetworkInfoViewController.h"

@implementation NetworkInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [_infos release];
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
    
    networkInfo = [[NetworkInfo alloc] init];
    
    // 표시한 정보를 저장. 
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    [info addObject:@"Status"];
    [info addObject:networkInfo.connected ? @"Connected" : @"Didconnected"];

    if (networkInfo.macAddress != nil && [networkInfo.macAddress length] > 0) {
        [info addObject:@"MAC"];
        [info addObject:networkInfo.macAddress];
    }
    if (networkInfo.wifiAddress != nil && [networkInfo.wifiAddress length] > 0) {
        [info addObject:@"wifi"];
        [info addObject:networkInfo.wifiAddress];
    }
    if (networkInfo.cellAddress != nil && [networkInfo.cellAddress length] > 0) {
        [info addObject:@"cell"];
        [info addObject:networkInfo.cellAddress];
    }
    
    _infos = info;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[NetworkInfoViewController alloc] initWithNibName:@"NetworkInfoViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*)   iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Network";
}

+ (BOOL) isEnableDevice
{
    return YES;
}



#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_infos count] / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeClip;
        
    }
    
    NSString *title = [_infos objectAtIndex:indexPath.row * 2];
    NSString *value = [_infos objectAtIndex:indexPath.row * 2 + 1];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = value;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // table에서 selection이 되어서 cell의 배경이 반전되는 현상을 막기위해서 
    // selection을 하지 못하도록 한다. 
    return nil;
}
@end
