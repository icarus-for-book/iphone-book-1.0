#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AccountViewController : UIViewController <NSFetchedResultsControllerDelegate, 
                                                     UITableViewDataSource, 
                                                     UITableViewDelegate> 
{
    // VIEW
    UITableView *_tableView;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

// setting 버튼을 누르면 수행.
- (IBAction) clickSetting:(id)sender;

@end
