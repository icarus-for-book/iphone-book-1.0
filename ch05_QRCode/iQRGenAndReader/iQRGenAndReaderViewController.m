//
//  iQRGenAndReaderViewController.m
//  iQRGenAndReader
//
//  Created by parkinhye on 11. 6. 19..
//  Copyright 2011 sss. All rights reserved.
//

#import "iQRGenAndReaderViewController.h"

@implementation iQRGenAndReaderViewController

@synthesize qrGenViewController, qrReaderViewController;

- (void)dealloc
{
    [qrGenViewController release];
    [qrReaderViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 버튼에 사용할 이미지를 읽어들인다
	UIImage *genImage = [UIImage imageNamed:@"QRGenButton.png"];
	UIImage *readerImage = [UIImage imageNamed:@"QRReaderButton.png"];
	
	// 버튼 생성 : QR Code 만들기
	CGRect genBtnRect = CGRectMake(65.0f, 330.0f, 190.0f, 42.0f);
	UIButton *genBtn = [[UIButton alloc] initWithFrame:genBtnRect];
    
    // 버튼 생성 : QR Code 검색
    CGRect readerBtnRect = CGRectMake(65.0f, 380.0f, 190.0f, 42.0f);
	UIButton *readerBtn = [[UIButton alloc] initWithFrame:readerBtnRect];
    
	// 버튼의 배경 이미지 설정
	[genBtn setBackgroundImage:genImage forState:UIControlStateNormal];
    [readerBtn setBackgroundImage:readerImage forState:UIControlStateNormal];
	//[button setBackgroundImage:touchImage forState:UIControlStateHighlighted];
	
    // 버튼 클릭시 action 설정
    [genBtn addTarget:self action:@selector(genClicked) forControlEvents:UIControlEventTouchDown];
    [readerBtn addTarget:self action:@selector(readerClicked) forControlEvents:UIControlEventTouchDown];
    
	// 버튼의 문자 설정
    //	[button setTitle:@"Click Me" forState:UIControlStateNormal];
    //	[button setTitle:@"Thanks" forState:UIControlStateHighlighted];	
    //	[button setFont:[UIFont boldSystemFontOfSize:12.0f]];
	
	// 버튼을 window에 붙인다
	[self.view addSubview:genBtn];
    [self.view addSubview:readerBtn];
    
	[genBtn release];
    [readerBtn release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.qrGenViewController = nil;
    self.qrReaderViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Button Action

- (void)genClicked
{
    /* 1. QR Generator 상세 화면 생성 - 메모리 할당 */
    self.qrGenViewController = [[iQRGenViewController alloc]initWithNibName:@"iQRGenViewController" bundle:nil];

    /* 2. 화면 전환시 애니메이션 효과 설정 */
    [UIView beginAnimations:nil context:nil];   // 에니메이션 시작 
	[UIView	setAnimationDuration:1.0f];    // 전환속도 실수형으로 줌(1.0 = 1초) 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // 속성(도움말) 회전속도가 느리게~일정~느리게
	[UIView	setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];    // FlipFromRight 좌측으로 회전,  forView:self 현재 뷰를 바꿈. 
	[UIView commitAnimations]; //애니메이션 완전히 종료

    /* 3. 화면 전환 */
    [self.view addSubview:qrGenViewController.view];
    
	NSLog(@"genClicked");
}

- (void)readerClicked
{
    /* 1. QR Reader 상세 화면 생성 */
    self.qrReaderViewController = [[iQRReaderViewController alloc]initWithNibName:@"iQRReaderViewController" bundle:nil];    
    
     /* 2. 화면 전환시 애니메이션 효과 설정 */	
	[UIView beginAnimations:@"left flip" context:nil];   // 에니메이션 시작 
	[UIView	setAnimationDuration:1.0];                   // 전환속도 실수형으로 줌(1.0 = 1초) 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // 속성(도움말) 회전속도가 느리게~일정~느리게
	[UIView	setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES]; // FlipFromRight 좌측으로 회전,  forView:self 현재 뷰를 바꿈. 
    [UIView commitAnimations]; //애니메이션 완전히 종료
    
    /* 3. 화면 전환 */
    //    [self presentModalViewController:qrReader animated:YES];
    [self.view addSubview:qrReaderViewController.view];
    
	NSLog(@"readerClicked");
}

@end
