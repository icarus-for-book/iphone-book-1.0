//
//  FavoriteListViewController.h
//  myComicViewer
//

#import <UIKit/UIKit.h>

// 찜한 파일 리스트를 보여주는 화면
@interface FavoriteListViewController : UITableViewController
{
    // iCloud 파일 리스트 조회를 위한 객체
    NSMetadataQuery *query;
    // iCloud 파일 객체 리스트 
    NSMutableArray *favoriteItems;
}


// 화면 닫음.
- (IBAction) close:(id)sender;

@end
