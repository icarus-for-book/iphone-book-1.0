//
//  ViewController.m
//  ipiano
//
//  Created by park inhye on 12. 1. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "InfoViewController.h"

#define GOOGLE_BANNER_ID @"a14f2765b159a16"

@implementation ViewController

@synthesize instrument, recorder, player, recState;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.instrument = [NSString stringWithString:@"Piano"];
    self.recState = FALSE;
    
    [self initADBanner];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark event action

/* 피아노 건반 클릭 시 호출되는 함수 */
-(IBAction)pressKeyDown:(id)sender {
    
    NSLog(@"press KeyDown");
    
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.instrument ofType:@"plist"];
	NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    
    if (array == nil) {
		NSLog(@"Could not load soundbank '%@'", plistPath);
		return;
	}
    
    int note = [sender tag];
    NSString *sampleRate = [array objectAtIndex:note];
    NSString *notePath = [[NSBundle mainBundle]pathForResource:sampleRate ofType:@"m4a"];
    
    if (recState == TRUE) {
        UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);AudioSessionSetActive(true);
    }
    
    AVAudioPlayer *theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:notePath] error:NULL];
    
    theAudio.delegate = self;
    
    [theAudio play];
}

/* 악기 변경 시 호출되는 함수 */
-(IBAction)changeInstrument:(id)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.instrument = @"Piano";
            NSLog(@"piano");
            break;
        case 1:
            self.instrument = @"Guitar";
            NSLog(@"Guitar");
            break;
        case 2:
            self.instrument = @"Organ";
            NSLog(@"Organ");
        default: 
            break;
            break;
    }
    
}

/* 녹음하고 리플레이시 호출되는 함수 */
-(IBAction)changeRecordPlay: (id) sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self toggleRecord];
            break;
        case 1:
            [self toggleStopRec];
            break;
        case 2:
            [self togglePlay];
            break;
        case 3:
            [self toggleStopPlay];
            break;
        default: 
            break;
    }
}

/* 상세 정보 버튼 클릭 시 호출되는 함수 */
-(IBAction)infoClicked {
	InfoViewController *infoViewCon=[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
	infoViewCon.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:infoViewCon animated:YES];
}

/* 녹음 시작 */
-(void) toggleRecord {
    self.recState = TRUE;
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    NSURL *url =[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/audio.aif"]];
    
    recorder= [[AVAudioRecorder alloc]initWithURL: url settings:nil error:nil];
    
    [recorder record];
}

/* 녹음 중단 */
-(void) toggleStopRec {
    
    [recorder stop];
    self.recState = FALSE;
}

/* 녹음 된 파일 재생 */
-(void) togglePlay {
    
    NSURL *url =[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/audio.aif"]];
    
    player= [[AVAudioPlayer alloc] initWithContentsOfURL: url error:nil];
    
    [player play];
}

/* 재생을 멈춤 */
-(void) toggleStopPlay {
    [player stop];
}

//-(IBAction)pressC:(id)sender {
//    NSLog(@"asdf");
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"PianoC3" ofType:@"m4a"];
//    AVAudioPlayer *theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
//    theAudio.delegate = self;
//    [theAudio play];
//}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        return YES;
//    }
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


/* 광고 배너 로딩 함수 */
- (void)initADBanner {
//    // iAd 배너
//    if( NSClassFromString(@"ADBannerView") ) {
//        // 1. iAd 배너 생성
//        adBanner = [[ADBannerView alloc] initWithFrame:CGRectZero];
//        
//        // 2. adBanner 프레임 설정(Landscape의 경우) 
//        [adBanner setRequiredContentSizeIdentifiers:
//         [NSSet setWithObjects:ADBannerContentSizeIdentifierLandscape,nil]];
//        
//        // 3. Landscape에 맞게 사이즈 자동 설정
//        [adBanner setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin];
//        
//        // 4. adBanner의 delegate를 설정
//        [adBanner setDelegate:self];
//        
//        // 5. adBanner 피아노 뷰에 탑재
//        [self.view addSubview:adBanner];
//
//        // 6. 생성된 된 배너 메모리 해제
//        [adBanner release];
//    }
    
    // 1. 애드몹 배너 생성
    adMobBanner = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    // 2. 애드몹 가로모드로 변경(세로모드 320*50, 가로모드 480*32) 
    adMobBanner.transform = CGAffineTransformMakeScale(480.0/320.0, 32.0/50.0);
    
    // 3. adMobBanner의 delegate를 설정 
    [adMobBanner setRootViewController:self];
    [adMobBanner setDelegate:self];
    
    // 4. 애드몹 사이트에서 할당받은 ID 설정
    [adMobBanner setAdUnitID:GOOGLE_BANNER_ID];
    
    // 5. adMobBanner 피아노 뷰에 탑재
    [self.view addSubview:adMobBanner];
    
    // 6. 생성된 된 배너 메모리 해제
    [adMobBanner release];
    
    // 7. 애드몹 광고 요청 인스턴스 생성
    GADRequest* requestAd = [GADRequest request];
    
    // 8. 테스트 설정. 테스트 끝난 후 꼭 주석 처리    
    [requestAd setTestDevices:[NSArray arrayWithObjects:[[UIDevice currentDevice] uniqueIdentifier], nil]];
    
    // 9. 애드몹 광고 요청하기 
    [adMobBanner loadRequest:requestAd];
}

#pragma mark -
#pragma mark iAD Delegate

/* 광고 취득 성공했을 경우 호출 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    // 1. 광고를 표시함
    [UIView beginAnimations:@"animateBannerAppear" context:nil];
    // 2. 광고 위치 변경 
    //adBanner.frame = CGRectOffset (banner.frame, 0, banner.frame.size.height);
    // 3. 애니메이션 실행
    [UIView commitAnimations];
}

/* 광고 취득에 실패했을 경우 호출 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // 1. 광고를 일시적으로 숨김
    [UIView beginAnimations:@"animateBannerOff" context:nil];
    // 2. 광고 위치 변경
    //adBanner.frame = CGRectOffset (banner.frame, 0, banner.frame.size.height);
    // 3. 애니메이션 실행
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark adMob Delegate

/* 광고 취득 성공했을 경우 호출 */
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView 
{
    // 1. 광고를 슬라이드 형식으로 표시함
    [UIView beginAnimations:@"BannerSlide" context:nil];
    // 2. 광고 위치 변경
    [adMobBanner setFrame:CGRectMake(0, 0, 480, 32)];
    // 3. 애니메이션 실행
    [UIView commitAnimations];
}

/* 광고 취득에 실패했을 경우 호출 */
- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error 
{
    // 1. 광고를 슬라이드 형식으로 표시함
    [UIView beginAnimations:@"BannerSlide" context:nil];
    // 2. 광고 위치 변경
    [adMobBanner setFrame:CGRectMake(0, 0, 480, 32)];
    // 3. 애니메이션 실행
    [UIView commitAnimations];
}
@end
