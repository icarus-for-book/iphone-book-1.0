//
//  InputViewController.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 7. 6..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputViewController;

enum {
    kInputViewTypeTextField,
    kInputViewTypeTextView,
    kInputViewTypeDatePicker,
};

typedef NSInteger InputViewType;


@protocol InputViewControllerDelegate <NSObject>

// 값이 변경되면 호출되는 함수
- (void) inputViewController:(InputViewController*)viewController changedValue:(id)value ofType:(InputViewType)type userInfo:(id)userinfo;

@end

// 사용자로 부터 받을 입력값을 받을 수 있는 기본 UI
@interface InputViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    
    
}

@property(nonatomic, retain) IBOutlet UITextField  *textField;
@property(nonatomic, retain) IBOutlet UITextView   *textView;
@property(nonatomic, retain) IBOutlet UIDatePicker *datePicker;


@property(nonatomic, assign) InputViewType inputType;
@property(nonatomic, retain) id currentValue;
@property(nonatomic, retain) id userInfo;
@property(nonatomic, assign) id <InputViewControllerDelegate> delegate;

// 원하는 input type으로 초기화
// @ref InputViewType
- (id) initWithType:(InputViewType) type;

// input component 재설정 ( input type에 따라서 )
- (void) relayoutController;
// 변경된 내용을 delegate에 보냄.
- (void) notifyChangeEvent;



@end
