//
//  SettingViewController.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "OptionViewController.h"
#import "Setting.h"


// 전체 설정의 Section들.
enum{
    kSectionPage,
    kSectionPageTransition,
    kSectionCount,
    kSectionFileList,
};

#define kSectionPageTitle  @"페이지"
#define kSectionPageTransitionTitle  @"화면전환"
#define kSectionFileListTitle @"파일리스트"

// kSectionPage의 항목들 
enum {
    kSectionPageFitScreen,
    kSectionPageSplit,
    kSectionPageCount
};

#define kSectionPageFitScreenTitle   @"화면 맞춤"
#define kSectionPageSplitTitle       @"이미지 나눔"

// kSectionPageTransition
enum {
    kSectionPageTransitionAnimation,
    kSectionPageTransitionOpenDirection,
    kSectionPageTransitionCount
};

#define kSectionPageTransitionAnimationTitle    @"애니메이션"
#define kSectionPageTransitionOpenDirectionTitle @"페이지 넘김 방향"


// kSectionTabAction
enum {
    kSectionTabActionEnableZoom,     
    kSectionTabActionCount
};

#define kSectionTabActionEnableZoomTitle        @"Zoom 허용"


// kSectionFileList
enum {
    kSectionFileListMode,
    kSectionFileListCount
};

#define kSectionFileListModeTitle        @"List Mode"



@implementation SettingViewController

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"설정";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 전체 Section의 갯수
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Section별 항목의 갯수.
    if(section == kSectionPage)
        return kSectionPageCount;
    else if(section == kSectionPageTransition)
        return kSectionPageTransitionCount;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Setting *setting = [Setting sharedSetting];
    
    // Section별, Item별로 Title과 기타 설정을 한다.
    
    if(indexPath.section == kSectionPage)
    {
        if(indexPath.row == kSectionPageFitScreen)
        {
            cell.textLabel.text = kSectionPageFitScreenTitle;
            cell.detailTextLabel.text = [setting stringForFitScreen:setting.fitScreen];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if(indexPath.row == kSectionPageSplit)
        {
            cell.textLabel.text = kSectionPageSplitTitle;
            cell.detailTextLabel.text = [setting stringForPageSplitMode:setting.pageSplitMode];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }else if(indexPath.section == kSectionFileList)
    {
        if(indexPath.row == kSectionFileListMode)
        {
            cell.textLabel.text = kSectionFileListModeTitle;
            cell.detailTextLabel.text = [setting stringForFileListMode:setting.fileListMode];
            
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } 
    }else if(indexPath.section == kSectionPageTransition)
    {
        if(indexPath.row == kSectionPageTransitionAnimation)
        {
            cell.textLabel.text = kSectionPageTransitionAnimationTitle;
            
            UISwitch *switchObject = [[[UISwitch alloc] init] autorelease];
            switchObject.on = setting.transitionAnimation;
            [switchObject addTarget:self action:@selector(changedEnableTransitionAnimation:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchObject;

            
        } else if(indexPath.row == kSectionPageTransitionOpenDirection)
        {
            cell.textLabel.text = kSectionPageTransitionOpenDirectionTitle;
            cell.detailTextLabel.text = [setting stringForOpenDirMode:setting.openDirMode];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //Section의 이름을 설정. 
    
    if(section == kSectionPage)
    {
        return kSectionPageTitle;
    }else if(section == kSectionFileList)
    {
        return kSectionFileListTitle;
    }else if(section == kSectionPageTransition)
    {
        return kSectionPageTransitionTitle;
    }

    return nil;
}

#pragma mark - Table view delegate

// 설정 값을 누를때 여러 Option 중에서 선택을 해야 한다. OptionViewController를 호출한다.
// OptionViewController가 표시하는 값들 중에서 사용자가 원하는 값을 선택하면 
// @select(optionView:isValueChanged:)가 호출된다.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting* setting = [Setting sharedSetting];
    
    if(indexPath.section == kSectionPage)
    {
        if(indexPath.row == kSectionPageSplit)
        {
            NSArray* options = [NSArray arrayWithObjects:
                                [setting stringForPageSplitMode:kPageSplitNone],
                                [setting stringForPageSplitMode:kPageSplitHorz],
                                [setting stringForPageSplitMode:kPageSplitVirt],
                                nil];
            OptionViewController *viewController = [[OptionViewController alloc] initWithTitle:kSectionPageSplitTitle options:options selectedIndex:setting.pageSplitMode];
            viewController.optionKind = kSectionPage*10+kSectionPageSplit;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        } else if(indexPath.row == kSectionPageFitScreen)
        {
            NSArray* options = [NSArray arrayWithObjects:
                                [setting stringForFitScreen:kFitScreenHorz],
                                [setting stringForFitScreen:kFitScreenVirt],
                                [setting stringForFitScreen:kFitScreenBoth],
                                [setting stringForFitScreen:kFitScreenNone],
                                nil];
            OptionViewController *viewController = [[OptionViewController alloc] initWithTitle:kSectionPageFitScreenTitle options:options selectedIndex:setting.fitScreen];
            viewController.optionKind = kSectionPage*10+kSectionPageFitScreen;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
    }else if(indexPath.section == kSectionFileList)
    {
        if(indexPath.row == kSectionFileListMode)
        {
            NSArray* options = [NSArray arrayWithObjects:@"간략 리스트", @"상세 리스트", nil];
            OptionViewController *viewController = [[OptionViewController alloc] initWithTitle:kSectionFileListTitle options:options selectedIndex:setting.fileListMode];
            viewController.optionKind = kSectionFileList*10+kSectionFileListMode;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        } 
    }else if(indexPath.section == kSectionPageTransition)
    {
        if(indexPath.row == kSectionPageTransitionOpenDirection)
        {
            NSArray* options = [NSArray arrayWithObjects:
                                [setting stringForOpenDirMode:kOpenDirRight],
                                [setting stringForOpenDirMode:kOpenDirLeft],
                                nil];
            OptionViewController *viewController = [[OptionViewController alloc] initWithTitle:kSectionPageTransitionOpenDirectionTitle options:options selectedIndex:setting.openDirMode];
            viewController.optionKind = kSectionPageTransition*10+kSectionPageTransitionOpenDirection;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
    }
}

// 화면 전화 Option이 변경되었을때.
- (void)changedEnableTransitionAnimation:(id)sender
{
    Setting* setting = [Setting sharedSetting];
    setting.transitionAnimation = [sender isOn];
}

// Zoom Option이 변경되었을때.
- (void)changedEnableZoomTitle:(id)sender
{
    Setting* setting = [Setting sharedSetting];
    setting.enableZoom = [sender isOn];
}


#pragma mark OptionViewControllerDelegate handler

// OptionViewController를 통해서 여러 option중에서 하나를 사용자가 선택하면 호출됨.
- (void) optionView:(OptionViewController*)viewController isValueChanged:(NSInteger)selectedIndex
{
    Setting *setting = [Setting sharedSetting];
    if (viewController.optionKind == kSectionPage*10+kSectionPageSplit) {
        setting.pageSplitMode = selectedIndex;
    } else if (viewController.optionKind == kSectionPage*10+kSectionPageFitScreen) {
        setting.fitScreen = selectedIndex;
    } else if (viewController.optionKind == kSectionFileList*10+kSectionFileListMode) {
        setting.fileListMode = selectedIndex;
    } else if (viewController.optionKind == kSectionPageTransition*10+kSectionPageTransitionOpenDirection) {
        setting.openDirMode = selectedIndex;   
    }
    
    [self.tableView reloadData];
}

@end
