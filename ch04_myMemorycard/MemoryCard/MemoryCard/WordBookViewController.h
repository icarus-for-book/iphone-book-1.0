#import <Foundation/Foundation.h>
#import "SectionHeaderView.h"
#import "LoadWordBookViewController.h"


@class ItemCellView;

// 단어장 리스트 화면.
// 섹션 타이트을 클릭하면 Table이 늘어나는 테이블 뷰
@interface WordBookViewController : UITableViewController 
<SectionHeaderViewDelegate, LoadWordBookViewControllerDelegate>
{
    // 카테고리 목록
    NSArray* _categories;
    // 커스텀 TableCellView 로드를 위한 임시 변수
    ItemCellView *_itemCell;
}

@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, assign) IBOutlet ItemCellView *itemCell;

// 단어장 추가 화면으로 전환
- (IBAction)onAddWordBook:(id)sender;

@end

