//
//  TorchViewController.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 9. 14..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "TorchViewController.h"
#import <AVFoundation/AVFoundation.h>

// private APIs
@interface TorchViewController()

// flash 디바이스 초기화 
- (void) initDevice;
// flash 동작 조절.
- (void) enableTorch:(BOOL)flag;

@end

@implementation TorchViewController

@synthesize avSession = _avSession;

- (void)dealloc
{
    [self enableTorch:NO];
    [_avSession release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initDevice];
        
        // flash가 켜졌이는지 표시할 flag 초기화
        _torchOn = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - event handler

- (IBAction)onToggleTorch:(id)sender
{
    if(_torchOn)
    {
        [self enableTorch:NO];
        [sender setSelected:NO];
    } else 
    {
        [self enableTorch:YES];
        [sender setSelected:YES];
    }
    
    
}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[TorchViewController alloc] initWithNibName:@"TorchViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*) iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Torch Control";
}

+ (BOOL) isEnableDevice
{
    // camera flash가 있는지 확인
    BOOL hasTorch = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
    return hasTorch;
}

#pragma mark - private method
- (void) initDevice
{
    // flash device 초기화
    // 현재까지 flash가 있는 것은 iPhone4G, iOS4 이상에서만 동작하기 때문에 
    // 아래와 같이 class를 조회한다.
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        // Video device 생성한다. 
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // touch가 있는지 확인한다. 
        if ([device hasTorch] && [device hasFlash]){
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];

            // Session과 device input, output를 연결시킨다.
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            [session beginConfiguration];
            [session addInput:input];
            [session addOutput:output];
            [session commitConfiguration];
            [output release];            
            
            // capture 시작.
            [session startRunning];

            self.avSession = session;
            [session release];
        }
    }
}
    
- (void) enableTorch:(BOOL)flag
{
    // Capture Device를 찾기. 
    // flash 속성 변환를 위해서 
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        
        if(flag){
            // turn on
            // flash키는 option을 set하고 flash를 지속적으로 
            // 켜 있도록 하기 위해서 torch option을 set한다. 
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            _torchOn = YES;
        } else {
            // turn off
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            _torchOn = NO;
        }
        [device unlockForConfiguration];
    }    
}
    


@end
