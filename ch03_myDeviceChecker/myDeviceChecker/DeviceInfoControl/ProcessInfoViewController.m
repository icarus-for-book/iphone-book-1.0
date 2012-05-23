//
//  ProcessInfoViewController.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "ProcessInfoViewController.h"

@interface ProcessInfoViewController()

@property (nonatomic, retain) NSArray *runningProcess;

// process list를 다시 로드함.
- (void) onReload;
@end

@implementation ProcessInfoViewController

@synthesize runningProcess = _runningProcess;
@synthesize cell=_cell;
@synthesize cellNib=_cellNib;

@synthesize tableView = _tableView;

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
    [_cellNib release];
    [_cell release];
    [_runningProcess release];
    [_tableView release];
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
    self.runningProcess = [ProcessInfo runningProcesses];
    
    // reload 버튼 추가
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onReload)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    [reloadButton release];
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

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[ProcessInfoViewController alloc] initWithNibName:@"ProcessInfoViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*)   iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Process";
}

+ (BOOL) isEnableDevice
{
    return YES;
}


#pragma mark - UITableViewDataSource handler


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.runningProcess.count;
}

- (id)cellNib {
    
    if (!_cellNib) {
        Class cls = NSClassFromString(@"UINib");
        if ([cls respondsToSelector:@selector(nibWithNibName:bundle:)]) {
            _cellNib = [[cls nibWithNibName:@"ProcessInfoCell" bundle:[NSBundle mainBundle]] retain];
        }
    }
    return _cellNib;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ProcessInfoCell *cell = (ProcessInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([self cellNib]) {
            [[self cellNib] instantiateWithOwner:self options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"ProcessInfoCell" owner:self options:nil];
        }
        cell = self.cell;
        self.cell = nil;
    }

    // Configure the cell.
    
    NSDictionary *dic = [self.runningProcess objectAtIndex:indexPath.row];
    
    cell.processName.text = [dic objectForKey:@"ProcessName"];
    cell.processId.text = [dic objectForKey:@"ProcessID"];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // table에서 selection이 되어서 cell의 배경이 반전되는 현상을 막기위해서 
    // selection을 하지 못하도록 한다. 
    return nil;
}


#pragma mark - private apis

- (void) onReload
{
    self.runningProcess = [ProcessInfo runningProcesses];
    [self.tableView reloadData];
}



@end
