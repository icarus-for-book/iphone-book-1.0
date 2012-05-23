//
//  OptionViewController.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 28..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionViewController;

@protocol OptionViewControllerDelegate <NSObject>

// 사용자가 option을 선택했을때 호출되는 함수로 |selectedIndex|는 사용자가 선택한
// index를 표시한다.
- (void) optionView:(OptionViewController*)viewController isValueChanged:(NSInteger)selectedIndex;

@end

// SettingViewController에서 사용하기 위한 ViewController로 
// 여러 선택 사항 중에 하나를 선택할 수 있는 UI를 제공하고 선택된 
// option 값을 전달하는 기능을 담당.
@interface OptionViewController : UITableViewController {

    NSString  *title;
    NSArray   *options;
    NSInteger selectedIndex;
    NSInteger optionKind;
    
    id<OptionViewControllerDelegate> delegate;
    
}

// 화면에 제목으로 표시한 문자열
@property(nonatomic, retain) NSString  *title;
// 화면에 표시할 선택 문자열들.
@property(nonatomic, retain) NSArray   *options;
// option들 중에 이미 선택된 문자열의 index
@property(nonatomic, assign) NSInteger selectedIndex;
// option 종류 ( 사용자가 지정하는 값 사용. )
@property(nonatomic, assign) NSInteger optionKind;
// 사용자가 선택한 값을 알릴때 사용하는 delgate
@property(nonatomic, assign) id<OptionViewControllerDelegate> delegate;


// title과 option으로 초기화한다.
- (id) initWithTitle:(NSString*)title 
             options:(NSArray*)options 
       selectedIndex:(NSInteger)index;

@end
