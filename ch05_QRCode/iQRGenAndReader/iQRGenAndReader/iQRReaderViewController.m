//
//  iQRReaderViewController.m
//  iQRGenAndReader
//
//  Created by parkinhye on 11. 6. 29..
//  Copyright 2011 sss. All rights reserved.
//

#import "iQRReaderViewController.h"
#import <AudioToolbox/AudioServices.h>

#define RESULT_SECTION      0

@implementation iQRReaderViewController

@synthesize dataSourceArray, readerTableView;

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
    [readerTableView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSourceArray = [[NSMutableArray alloc]initWithCapacity:1];
    [self.dataSourceArray addObject:[NSNull null]];
    
    /* 1. Readed type : QR or Barcode */
    UITableViewCell *typeCell = [UITableViewCell new];
    typeLabel = [typeCell.textLabel retain];
    
    /* 2. 검색된 데이타 */
    UITableViewCell *dataCell = [UITableViewCell new];
    dataLabel = [dataCell.textLabel retain];
    dataLabel.numberOfLines = 0;
    dataLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    
    /* 3. 검색 이미지 */
    UITableViewCell *imageCell = [UITableViewCell new];
    imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    UIView *content = imageCell.contentView;
    imageView.frame = content.bounds;
    [content addSubview:imageView];
    [imageView release];
    
    NSArray *results = [NSArray arrayWithObjects:typeCell, dataCell, imageCell, nil];
    
    [self.dataSourceArray replaceObjectAtIndex:RESULT_SECTION withObject:results];
        
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.dataSourceArray = nil;
    self.readerTableView = nil;
    
    [imageView release];
    imageView = nil;
    [typeLabel release];
    typeLabel = nil;
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
    if(!idx)
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, NULL, NULL);
}

#pragma mark - ZBarReaderDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 1. 디코드 결과 얻기
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results) {//just grab the first barcode
        break;
    }
        
    // 2. 바코드 검색된 이미지 저장하기 
    imageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // 3. 검색된 데이타 저장하기
    [self performSelector: @selector(presentResult:) withObject: symbol afterDelay: .001];
    
    // 4. 이부분은 스캔시, 삐 소리가 나게 하는 부분
    [self performSelector: @selector(playBeep) withObject: nil afterDelay: 0.01];
    
    // 5.dismiss the controller (NB dismiss from the *reader*!)
    [picker dismissModalViewControllerAnimated: YES];        
}

#pragma mark - UITableViewDelegate

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//

// 중요! - 셀을 선택했을때 호출되는 메서드 - indexPath는 선택된 셀의 NSIndexPath객체
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.row == 1) {
        
        //NSURL *url = [NSURL URLWithString:dataLabel.text];  
        if(![dataLabel.text hasPrefix:@"http://"]) {
            dataLabel.text = [NSString stringWithFormat:@"http://%@", dataLabel.text];
        }
        NSURL *url = [NSURL URLWithString:dataLabel.text];  
        [[UIApplication sharedApplication] openURL:url];
    }
    else if(indexPath.row == 2) {
        
        //UIAction Sheet 구성
        if(imageView.image != nil) {
            [[[[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Save Image" otherButtonTitles: @"Save Image", nil] autorelease] showInView: self.view];

        }
    }
}

//셀의 높이를 설정하는 메서드
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row) {
        case 0: return(44);
        case 1: return(dataHeight);
        case 2: return(300);
        default: assert(0);
    }
    return(44);
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
	return @"QR Decode Results";
}

#pragma mark - Event Creat

- (void) presentResult: (ZBarSymbol*) sym
{
    // 1. 바코드 데이타 저장하기
    found = !!sym;
    NSString *typeName = sym.typeName;  //sym.typeName는 바코드 타입
    typeLabel.text = typeName;
    NSString *data = sym.data;          //sym.data는 바코드 번호 및 QR 데이타
    dataLabel.text = data;
    
    NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:\n");
    NSLog(@"type=%@ data=%@\n", sym.typeName, data);
    
    // 2. 바코드 이미지 사이즈 조정하기 
    CGSize size = [data sizeWithFont: [UIFont systemFontOfSize: 17]
                   constrainedToSize: CGSizeMake(288, 2000)
                       lineBreakMode: UILineBreakModeCharacterWrap];
    dataHeight = size.height + 26;
    if(dataHeight > 2000)
        dataHeight = 2000;
    
    // 3. 테이블에 인식된 데이타 표현하기
    [self.readerTableView reloadData];
    [self.readerTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: 0 inSection: 0] atScrollPosition:UITableViewScrollPositionTop animated: NO];
}

- (void) playBeep {
    // 1. 진동
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (IBAction) readBackBtnClicked {
    
    /* 1. 애니메이션 효과 */
    [UIView beginAnimations:@"back" context:nil];   // 에니메이션 시작 
    [UIView setAnimationDuration:1.0];  // 전환속도 실수형으로 줌(1.0 = 1초) 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // 속성(도움말) 회전속도가 느리게~일정~느리게
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:YES];    // 왼쪽으로 플립,  forView:self 현재 뷰를 바꿈. 
    [UIView commitAnimations];  //애니메이션 완전히 종료
    
    /* 2. 화면 전환 */
    [self.view removeFromSuperview];
    
    NSLog(@"readBackBtnClicked");
}

- (IBAction) scanButtonClicked {
    
    found = paused = NO;
    imageView.image = nil;
    typeLabel.text = nil;
    dataLabel.text = nil;
    
    [self.readerTableView reloadData];
    
    // 1. QR code Reader 생성 : present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    // 2. 추가적인 QR reader 설정
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0]; //disable rarely used I2/5 to improve performance
    
    // 3. present and release the controller
    [self presentModalViewController:reader animated:YES];    
    [reader release];
}

@end
