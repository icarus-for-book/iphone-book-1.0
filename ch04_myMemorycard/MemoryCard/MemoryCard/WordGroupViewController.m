//
//  WordGroupViewController.m
//  MemoryCard
//
//  Created by 진섭 안 on 11. 7. 30..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "WordGroupViewController.h"
#import "WordCardViewController.h"
#import "ItemCellView.h"


@implementation WordGroupViewController

@synthesize groups = _groups;
@synthesize itemCell = _itemCell;
@synthesize labelCellNib = _labelCellNib;

- (void)dealloc
{
    [_labelCellNib release];
    [_itemCell release];
    [_groups release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set title of navigation bar
    self.navigationItem.title = @"Word Group";

    // setup tableview
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_main_background.png"]];
    self.tableView.backgroundView = backgroundImage;
    [backgroundImage release];
    
    // change separator color
    self.tableView.separatorColor = [UIColor blackColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    ItemCellView *cell = (ItemCellView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        Class cls = NSClassFromString(@"UINib");
        if ([cls respondsToSelector:@selector(nibWithNibName:bundle:)]) {
            if (self.labelCellNib == nil) {
                self.labelCellNib = [[cls nibWithNibName:@"ItemCellView" bundle:[NSBundle mainBundle]] retain];
            }
            
            [self.labelCellNib instantiateWithOwner:self options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"ItemCellView" owner:self options:nil];
        }
        
        cell = self.itemCell;
        self.itemCell = nil;
    }
    
    // Configure the cell...
    MCGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = group.title;
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return 52;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 암기모드.
    MCGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    // skip if it has no words.
    if ([group countOfWords] == 0 ) {
        return;
    }
    
    if ([group countOfUnmemorized] == 0 )
    {
        // 경고창.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"암기할 단어가 없습니다. 초기화후 다시 학습하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        
        alertView.tag = indexPath.row;
        
        [alertView show];
        
        [alertView release];
    } else {
        
        [self startStudy:group];
    
    }
}

- (void) startStudy : (MCGroup*) group
{
    
    WordCardViewController *viewController = [[WordCardViewController alloc] initWithNibName:@"WordCardViewController" bundle:nil];
    
    viewController.words = [group wordsOfUnmemorized];
    viewController.wordgroup = group;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button : %d",buttonIndex);
    
    if (buttonIndex == 1) {
        
        MCGroup *group = [self.groups objectAtIndex:alertView.tag];

        
        // reset study status
        for(MCWord *word in [group wordsOfMemorized])
        {
            word.memorized = NO;
        }
            
        
        [self startStudy:group];
        
        
    }
}

@end
