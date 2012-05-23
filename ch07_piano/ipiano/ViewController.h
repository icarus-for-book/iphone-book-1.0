//
//  ViewController.h
//  ipiano
//
//  Created by park inhye on 12. 1. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import <iAd/iAd.h> 
#import "GADBannerViewDelegate.h"
#import "GADBannerView.h"

@interface ViewController : UIViewController <AVAudioPlayerDelegate, ADBannerViewDelegate, GADBannerViewDelegate> {
    //AVAudioPlayer *theAudio;
    /* 광고 배너 */
    ADBannerView* adBanner; // iAD
    GADBannerView* adMobBanner; // 애드몹
}

@property (nonatomic, retain) NSString *instrument;
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) AVAudioPlayer *player;
@property BOOL recState;


-(IBAction)changeInstrument:(id)sender;
-(IBAction)changeRecordPlay:(id)sender;
-(IBAction)pressKeyDown:(id)sender;
-(IBAction)infoClicked;

-(void)toggleRecord;
-(void)togglePlay;
-(void)toggleStopRec;
-(void)toggleStopPlay;

- (void)initADBanner;
//-(IBAction)pressC:(id)sender;

@end
