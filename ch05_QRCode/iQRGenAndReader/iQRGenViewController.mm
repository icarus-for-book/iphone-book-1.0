//
//  iQRGenViewController.mm
//  iQRGenAndReader
//
//  Created by parkinhye on 11. 6. 29..
//  Copyright 2011 sss. All rights reserved.
//

#import "iQRGenViewController.h"
#import "QREncoder.h"

@implementation iQRGenViewController

@synthesize dataSourceArray, genTableView, isKeyPressed, linkAddrData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [dataSourceArray release];
    [genTableView release];
    [linkAddrData release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// for general screen
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0
#define kTextFieldWidth         280.0

//the qrcode is square. now we make it 200 pixels wide
#define qrcodeImageDimension    200

const NSInteger kViewTag = 1;

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
    NSLog(@"textField = %@", textField.text);
    self.linkAddrData = textField.text;
	return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.dataSourceArray = [[NSMutableArray alloc]initWithCapacity:1];
    [self.dataSourceArray addObject:[NSNull null]];
    
    /* 1. 테이블 첫번째 쎌 - Linked URL */    
    UITableViewCell *typeCell = [[[UITableViewCell alloc]init]autorelease];
    UILabel *typeLabel = [typeCell textLabel];
    [typeLabel setText:@"Linked URL"];
    
    /* 2. 테이블 투번째 쎌 - Link 주소 입력받는 곳 */
    UITableViewCell *dataCell = [[[UITableViewCell alloc]init]autorelease];

    /* 2.1 텍스트필드 생성 */
    CGRect frame = CGRectMake(kLeftMargin, 4.0, kTextFieldWidth, kTextFieldHeight);
    UITextField *linktextField = [[UITextField alloc] initWithFrame:frame];
    
    linktextField.borderStyle = UITextBorderStyleBezel;
    linktextField.textColor = [UIColor blackColor];
    linktextField.font = [UIFont systemFontOfSize:17.0];
    linktextField.placeholder = @"Enter url(ex:www.google.com)";
    linktextField.backgroundColor = [UIColor whiteColor];
    linktextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    linktextField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
    linktextField.returnKeyType = UIReturnKeyDone;
    
    linktextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    
    linktextField.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
    
    linktextField.delegate = self;	// 
    
    /* 2.2 두번째 셀에 텍스트 필드 삽입 */
    [dataCell addSubview:linktextField];
    [linktextField release];
    
    /* 3. 테이블 세번째 쎌 - QR 코드 생성 결과 표시 */
    UITableViewCell *resultCell = [[[UITableViewCell alloc]init]autorelease];
    qrResultLabel = [resultCell textLabel];
    [qrResultLabel setText:@"QRcode Gen Result"];
    
    /* 4. 테이블 네번째 쎌 - 생성된 QR 이미지 */
    UITableViewCell *imageCell = [[[UITableViewCell alloc]init]autorelease];

    /* 4.1 이미지 위치 중앙 정렬 */
    CGRect parentFrame = self.view.frame;
    CGFloat x = (parentFrame.size.width - qrcodeImageDimension) / 2.0;
    CGFloat y = (240 - qrcodeImageDimension) / 2.0;    
    CGRect qrcodeImageViewFrame = CGRectMake(x, y, qrcodeImageDimension, qrcodeImageDimension);
    imageView = [[UIImageView alloc] initWithFrame:qrcodeImageViewFrame];
    
    /* 4.2 이미지 셀에 이미지 뷰 삽입 */
    [imageCell addSubview:imageView];  
    
    NSArray *results = [NSArray arrayWithObjects:typeCell, dataCell, resultCell, imageCell, nil];
    
    [self.dataSourceArray replaceObjectAtIndex:0 withObject:results];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.dataSourceArray = nil;
    self.genTableView = nil;
    self.linkAddrData = nil;
    
    [imageView release];
    imageView = nil;
    [dataLabel release];
    dataLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIActionSheetDelegate

- (void)  actionSheet: (UIActionSheet*) sheet clickedButtonAtIndex: (NSInteger) idx
{
    // 1. cancle 버튼 클릭시
    if(idx == sheet.cancelButtonIndex)
        return;
    
    // 2. image save 버튼시
    idx -= sheet.firstOtherButtonIndex;
    if(idx)
        UIImageWriteToSavedPhotosAlbum([imageView image], nil, NULL, NULL);
}

#pragma mark - UITableViewDelegate

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//

// 중요! - 셀을 선택했을때 호출되는 메서드 - indexPath는 선택된 셀의 NSIndexPath객체
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
       
    if(indexPath.row == 3) {
        if([imageView image]!= nil) {
            [[[[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Save Image" otherButtonTitles: nil, nil] autorelease] showInView: self.view];
            
        }

    }
}

//셀의 높이를 설정하는 메서드
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row) {
        case 0: return(40);
        case 1: return(40);
        case 2: return(40);
        case 3: return(240);
        default: assert(0);
    }
    return(40);
}

#pragma mark -
#pragma mark UITableViewDataSource

// to determine which UITableViewCell to be used on a given row.
//

//행의 갯수 - 그룹(section) 당 행의 개수를 설정하는 메서드 : 필수
//section의 수를 설정하지 않는 경우 하나의 section만 있는 것으로 간주
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *sectionData = [dataSourceArray objectAtIndex: section];
    return(sectionData.count);
}

//행의 정보 - 행(셀)을 그려주는 메서드 : 필수
//indexPath는 row와 section을 프로퍼티로 갖는 셀에대한 포인트 클래스
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return([[self.dataSourceArray objectAtIndex: indexPath.section]
            objectAtIndex: indexPath.row]);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataSourceArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"QR Generator";
}

#pragma mark - Event Creat

- (IBAction) genBackBtnClicked {
    
    /* 1. 애니메이션 효과 */
    [UIView beginAnimations:@"back" context:nil];   // 에니메이션 시작 
    [UIView setAnimationDuration:1.0];  // 전환속도 실수형으로 줌(1.0 = 1초) 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // 속성(도움말) 회전속도가 느리게~일정~느리게
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view.superview cache:YES];    // CurlDown 아래로 말려 내려감,  forView:self 현재 뷰를 바꿈. 
    [UIView commitAnimations];  //애니메이션 완전히 종료
    
    /* 2. 화면 전환 */
    [self.view removeFromSuperview];
    
    NSLog(@"genBackBtnClicked");
}

- (IBAction) showBarcodeImage: (id) sender
{
    /* 1.linkAddrData 에러 체크 */    
    if(linkAddrData == nil || [linkAddrData length] == 0) {
        NSLog(@"Please Enter URL in Edit Box.");
        [qrResultLabel setText:@"Please Enter URL in Edit Box."];
        return;
    }
    
    /* 2.상태 체크 */    
	self->isKeyPressed = TRUE;
    
    /* 3. 테이블 세번째 쎌 - QR 코드 생성 결과 표시 */  
    [qrResultLabel setText:@"QRcode 생성이 완료되었습니다."];

    /* 4. 테이블 네번째 쎌 - QR 코드 생성 이미지 표시 */ 
    /* 4.1 first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version */
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:self.linkAddrData];
    
    /* 4.2 then render the matrix */
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    
    /* 4.3 put the image into the view */
    [imageView setImage:qrcodeImage];
    
    /* 5. 테이블 리로드 */
    [self.genTableView reloadData];
    [self.genTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: 0
                                                                 inSection: 0] atScrollPosition:UITableViewScrollPositionTop animated: NO];
    
}

@end
