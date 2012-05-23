#import <Foundation/Foundation.h>

@protocol SectionHeaderViewDelegate;


@interface SectionHeaderView : UIView {
}

@property (nonatomic, assign, getter = isHeaderOpened) BOOL headerOpened;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id <SectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end



@protocol SectionHeaderViewDelegate <NSObject>

@optional
// 섹션을 펼때
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
// 섹션을 접을때
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end

