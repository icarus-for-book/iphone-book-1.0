#import <UIKit/UIKit.h>

#import "LoadingView.h"


@class PicasawebService;

// picasa 계정 추가.
@interface AddAccountViewController : UIViewController {
    NSManagedObjectContext *_managedContext;
    UITextField *_username;
    UITextField *_password;
    LoadingView *_loadingView;
    
}

// 로딩 중임을 표시하기 위한 로딩 뷰 
@property(nonatomic, retain) LoadingView *loadingView;
// 코어 데이터를 사용을 위한 컨텍스트
@property(nonatomic,retain) NSManagedObjectContext *managedContext;
// 사용자 아이디 
@property(nonatomic,retain) IBOutlet UITextField *username;
// 사용자 패스워드
@property(nonatomic,retain) IBOutlet UITextField *password;

// 구글 계정 생성버튼의 핸들러 
- (IBAction) clickCreateAccount:(id)sender;

@end
