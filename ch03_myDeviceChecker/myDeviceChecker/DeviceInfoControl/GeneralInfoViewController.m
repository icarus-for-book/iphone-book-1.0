//
//  GeneralInfoViewController.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "GeneralInfoViewController.h"
#import "DeviceInfo.h"



@implementation GeneralInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [_headerOfInfos release];
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

    DeviceInfo *info = [[DeviceInfo alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";

    // 표시한 정보를 저장. 
    NSArray *info1 = [[NSArray alloc] initWithObjects:
              @"Boot Time", [dateFormatter stringFromDate:info.bootTime],
              @"Model", info.model,
              @"Owner", info.owner,
              @"System", info.sysVersion,
              nil];

    // UUID 정보 저장. 
    NSArray *info2 = [[NSArray alloc] initWithObjects:
                      @"UUID", @"",
                      @"",info.uuid,
                      nil];
    
    
    _infos = [[NSArray alloc] initWithObjects:info1,info2, nil];
    
    [info1 release];
    [info2 release];
    [dateFormatter release];
    [info release];

}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[GeneralInfoViewController alloc] initWithNibName:@"GeneralInfoViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*)   iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"general information";
}

+ (BOOL) isEnableDevice
{
    return YES;
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_infos objectAtIndex:section] count] / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    NSArray *info = [_infos objectAtIndex:indexPath.section];
    
    NSString *title = [info objectAtIndex:indexPath.row * 2];
    NSString *value = [info objectAtIndex:indexPath.row * 2 + 1];
    
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
