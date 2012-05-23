//
//  DetailViewController.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "ComicInfo.h"
#import "ImageViewerViewController.h"
#import "ZipArchive.h"
#import "FilelistViewController.h"


@interface DetailViewController()// private method
@end


@implementation DetailViewController

@synthesize info;
@synthesize delegate = _delegate;

- (void)dealloc
{

    [info release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"만화 상세보기";
}

- (void)viewDidAppear:(BOOL)animated
{
    if([self.tableView indexPathForSelectedRow] == nil && info.lastPage > 0){
        NSIndexPath *cur = [NSIndexPath indexPathForRow:info.lastPage inSection:0];
        [self.tableView selectRowAtIndexPath:cur animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [info.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    ZipEntry* entry = [info.files objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.filename;
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    
    return cell;
}

#pragma mark - Table view delegate

// 원하는 페이지를 선택하면 바로 이동.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate != nil) {
        info.lastPage = indexPath.row;
        [self.delegate detailView:self didSelected:self.info];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    // ImageViewerViewController를 만들고 화면이동 시킴.
    NSString *NibName = @"ImageViewerViewController";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NibName = @"ImageViewerViewController-iPad";
    }
    
    info.lastPage = indexPath.row;
    ImageViewerViewController *viewController = [[ImageViewerViewController alloc] initWithNibName:NibName bundle:nil];
    viewController.info = info;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end

