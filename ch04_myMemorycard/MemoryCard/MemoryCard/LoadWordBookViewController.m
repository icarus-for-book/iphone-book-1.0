//
//  LoadWordBookViewController.m
//  MemoryCard
//
//  Created by jinni on 11. 8. 2..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "LoadWordBookViewController.h"
#import "LoadingView.h"
#import "WordLoader.h"

#define kSectionLocal 0
#define KSectionRemote 1

@interface LoadWordBookViewController()

// 현재 디렉토리에서 파일 목록 가져오기
- (void) updateLoadableFiles;

@end


@implementation LoadWordBookViewController

@synthesize filesInLocal = _filesInLocal;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _filesInLocal = [[NSArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_filesInLocal release];
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

    [self updateLoadableFiles];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 0;
    if (self.filesInLocal.count > 0) {
        ++count;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSectionLocal) 
    {
        return self.filesInLocal.count;
    }
    
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == kSectionLocal) 
    {
        return @"Local";
    } else if (section == KSectionRemote)
    {
        return @"Remote";
    }
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSInteger section = indexPath.section;
    
    if (section == kSectionLocal) 
    {
        NSURL *url = [self.filesInLocal objectAtIndex:indexPath.row];
        cell.textLabel.text = [[url pathComponents] lastObject];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    NSURL *url = nil;
    
    if (section == kSectionLocal) 
    {
        url = [self.filesInLocal objectAtIndex:indexPath.row];
    }
    
    LoadingView *loadingView = [LoadingView loadingViewInView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        WordLoader *wordLoader = [[WordLoader alloc] init];
        [wordLoader loadContentsForURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // loading 화면 제거
            [loadingView removeView];
            
            // 변경 내용을 통지 ( WordBookViewController에 알리는 것 )
            if(self.delegate) {
                [self.delegate loadWordBookViewControllerDidChanged:self];
            }
            
        });
    });
    
}

- (void) updateLoadableFiles
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Documents 폴더 경로 찾기
    NSURL *document = [[[NSFileManager defaultManager] 
                        URLsForDirectory:NSDocumentDirectory 
                                inDomains:NSUserDomainMask] lastObject];
    
    // Documents 폴더의 파일 목록을 얻는다.
    NSArray *tempArray = [fileManager 
                          contentsOfDirectoryAtURL:document 
                          includingPropertiesForKeys:nil 
                          options:NSDirectoryEnumerationSkipsHiddenFiles 
                          error:NULL];
    
    // xml 파일을 저장한 임시 배열
    NSMutableArray *loadableFiles = [[NSMutableArray alloc] initWithCapacity:tempArray.count];
    
    NSArray *allowExts = [NSArray arrayWithObjects:@"xml",@"json",@"plist", nil];
    
    // 확장자로 필터링
    for( NSURL *url in tempArray )
    {
        if ( [allowExts containsObject:[url pathExtension]] )
        {
            [loadableFiles addObject:url];
        }
    }
    
    self.filesInLocal = loadableFiles;
    [loadableFiles release];
    
    // 업데이트된 파일을 화면에 표시한다.
	[self.tableView reloadData];
}

@end
