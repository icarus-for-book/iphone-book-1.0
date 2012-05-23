//
//  SettingViewController.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "OptionViewController.h"

// 전체 설정의 Section들.
enum{
    kSectionSetting,
    kSectionAbout,
    kSectionCount
};

// kSectionSetting의 항목들 
enum {
    kSectionSettingPhotoSize,
    kSectionSettingAlbumSortOrder,
    kSectionSettingCount
};

#define kSectionSettingPhotoSizeTitle        @"사진 사이즈"
#define kSectionSettingAlbumSortOrderTitle   @"앨범 정렬"

// kSectionAbout 항목
enum {
    kSectionAboutItem,
    kSectionAboutCount
};

#define kSectionAboutItemTitle  @"About"

@interface SettingViewController()

// 완료했을때.
- (void) onClickDone:(id)sender;

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [setting release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    setting = [[Setting sharedSetting] retain];
    self.navigationItem.title = @"Settings";
    
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onClickDone:)];
    
    self.navigationItem.rightBarButtonItem = buttonDone;
    
    [buttonDone release];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [setting flush];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kSectionSetting:
            return kSectionSettingCount;
        case kSectionAbout:
            return kSectionAboutCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell
    switch (indexPath.section) {
        case kSectionSetting:
            
            switch (indexPath.row) {
                case kSectionSettingPhotoSize:
                    cell.textLabel.text = kSectionSettingPhotoSizeTitle;
                    cell.detailTextLabel.text = [Setting stringForDefaultPhotoSize:setting.defaultPhotoSize];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case kSectionSettingAlbumSortOrder:
                    cell.textLabel.text = kSectionSettingAlbumSortOrderTitle;
                    cell.detailTextLabel.text = [Setting stringForAlbumSortOrder:setting.albumSortOrder];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                    break;
            }
            
            break;
            
        case kSectionAbout:
            
            cell.textLabel.text = kSectionAboutItemTitle;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            break;
            
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    switch (indexPath.section) {
        case kSectionSetting:
            
            switch (indexPath.row) {
                case kSectionSettingPhotoSize:
                {
                    OptionViewController *viewController = 
                        [[OptionViewController alloc] 
                           initWithTitle:kSectionSettingPhotoSizeTitle 
                                    options:[NSArray arrayWithObjects:
                                                    [Setting stringForDefaultPhotoSize:kPhotoSizeOrignal],
                                                    [Setting stringForDefaultPhotoSize:kPhotoSize1600px],
                                                    [Setting stringForDefaultPhotoSize:kPhotoSize1280px],
                                                    [Setting stringForDefaultPhotoSize:kPhotoSize1024px],
                                                    [Setting stringForDefaultPhotoSize:kPhotoSize800px],
                                                    [Setting stringForDefaultPhotoSize:kPhotoSize640px],
                                                    [Setting stringForDefaultPhotoSize:kPhotoSize512px],
                                                    nil]
                                selectedIndex:setting.defaultPhotoSize];
                    viewController.optionKind = kSectionSetting*10+kSectionSettingPhotoSize;
                    viewController.delegate = self;
                    [self.navigationController pushViewController:viewController animated:YES];
                    
                    [viewController release];
                }

                    break;
                case kSectionSettingAlbumSortOrder:
                {
                    OptionViewController *viewController = 
                       [[OptionViewController alloc] 
                            initWithTitle:kSectionSettingAlbumSortOrderTitle 
                                  options:[NSArray arrayWithObjects:
                                            [Setting stringForAlbumSortOrder:kAlbumOrderAlbumname],
                                            [Setting stringForAlbumSortOrder:kAlbumOrderUpdateDate],
                                            [Setting stringForAlbumSortOrder:kAlbumOrderAlbumDate],
                                            nil]
                            selectedIndex:setting.albumSortOrder];
                    viewController.optionKind = kSectionSetting*10+kSectionSettingAlbumSortOrder;
                    viewController.delegate = self;
                    [self.navigationController pushViewController:viewController animated:YES];
                    [viewController release];
                }
                    
                    break;
            }
            
            break;
            
        case kSectionAbout:
        {
            AboutViewController *viewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
            
    }    
}


#pragma mark - 
#pragma mark OptionViewController Handler

- (void) optionView:(OptionViewController*)viewController isValueChanged:(NSInteger)selectedIndex
{
    switch (viewController.optionKind) {
        case kSectionSetting*10+kSectionSettingPhotoSize:
            setting.defaultPhotoSize = selectedIndex;
            [self.tableView reloadData];
            break;
        case kSectionSetting*10+kSectionSettingAlbumSortOrder:
            setting.albumSortOrder = selectedIndex;
            [self.tableView reloadData];
            break;
    }
    
}

- (void) onClickDone:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
