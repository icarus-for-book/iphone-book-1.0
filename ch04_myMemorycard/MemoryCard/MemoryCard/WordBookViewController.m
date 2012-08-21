#import "WordBookViewController.h"
#import "ItemCellView.h"
#import "SectionInfo.h"
#import "SectionHeaderView.h"
#import "MCWordDataDao.h"
#import "WordGroupViewController.h"
#import "LoadWordBookViewController.h"

#pragma mark - ExpandableTableViewController Private APIs

@interface WordBookViewController ()

@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) CGFloat initialPinchHeight;
@property (nonatomic, assign) NSInteger uniformRowHeight;

@end

@implementation WordBookViewController

@synthesize categories=_categories;
@synthesize sectionInfoArray=_sectionInfoArray;
@synthesize itemCell=_itemCell;
@synthesize uniformRowHeight=_rowHeight;
@synthesize openSectionIndex=_openSectionIndex;
@synthesize initialPinchHeight=initialPinchHeight_;

#pragma mark Memory management

-(void)dealloc {
    
    [_categories release];
    [_sectionInfoArray release];
    [_itemCell release];
    [super dealloc];
    
}

#pragma mark Initialization and configuration

- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    MCWordDataDao *dao = [MCWordDataDao sharedDao];
    self.categories = [dao categories];
    
    // setup tableview
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_main_background.png"]];
    self.tableView.backgroundView = backgroundImage;
    [backgroundImage release];
    
    // change separator color
    self.tableView.separatorColor = [UIColor blackColor];

    // Set up default values.
    self.tableView.sectionHeaderHeight = 52;
    
    // add button
    UIBarButtonItem *buttonAddWordBook = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddWordBook:)];
    
    self.navigationItem.rightBarButtonItem = buttonAddWordBook;
    [buttonAddWordBook release];
    
	/*
     The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
     */
    _rowHeight = 52;
    _openSectionIndex = NSNotFound;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated]; 
    
    MCWordDataDao *dao = [MCWordDataDao sharedDao];
    self.categories = [dao categories];
    
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (MCCategory *category in self.categories) {
			
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.category = category;
			
			[infoArray addObject:sectionInfo];
			[sectionInfo release];
		}
		
		self.sectionInfoArray = infoArray;
		[infoArray release];
	}
    
    [self.tableView reloadData];
	
}


- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    // To reduce memory pressure, reset the section info array if the view is unloaded.
	self.sectionInfoArray = nil;
}


#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return [self.categories count];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.category books] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    ItemCellView *cell = (ItemCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        Class cls = NSClassFromString(@"UINib");
        if ([cls respondsToSelector:@selector(nibWithNibName:bundle:)]) {
            UINib *_labelCellNib = [[cls nibWithNibName:@"ItemCellView" bundle:[NSBundle mainBundle]] retain];
            [_labelCellNib instantiateWithOwner:self options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"ItemCellView" owner:self options:nil];
        }
        
        cell = self.itemCell;
        self.itemCell = nil;
    }
    
    MCCategory *category = (MCCategory *)[[self.sectionInfoArray objectAtIndex:indexPath.section] category];
    MCBook *book = [category.books objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = book.title;
    
    return cell;
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    // 커스텀 헤더 뷰를 생성
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
		NSString *title = sectionInfo.category.title;
        sectionInfo.headerView = [[[SectionHeaderView alloc] 
                                   initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 52) 
                                   title:title 
                                   section:section 
                                   delegate:self] autorelease];
    }
    
    return sectionInfo.headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return 52;
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // change view to choose groups of wordbook
    WordGroupViewController *viewController = [[WordGroupViewController alloc] initWithStyle:UITableViewStylePlain];
    
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    MCBook *book = [sectionInfo.category.books objectAtIndex:indexPath.row];
    
    viewController.groups = book.groups;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}


#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView 
           sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	sectionInfo.open = YES;

    // 십입할 셀의 인덱스들을 만든다.
    NSInteger countOfRowsToInsert = [sectionInfo.category.books count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }

    // 삽입하는 애니메이션 설정.
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationTop;
    
    // 셀 삽입.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView endUpdates];
    
    [indexPathsToInsert release];
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        
        // 제거할 셀들을 찾는다.
        
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        
        // 셀을 제거한다.
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [indexPathsToDelete release];
    }
}



- (IBAction)onAddWordBook:(id)sender
{
    LoadWordBookViewController *viewController = [[LoadWordBookViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    
    // 변경 통지를 위한 delegate 추가
    viewController.delegate = self;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
}

- (void)loadWordBookViewControllerDidChanged:(LoadWordBookViewController*)vc
{
    // 테이블을 다시 로드시기키위해서
    // self.sectionInfoArray 를 nil로 설정한다.
    
    self.sectionInfoArray = nil;
}




@end
