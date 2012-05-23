//
//  CameraViewController.m
//  myDeviceChecker
//
//  Created by 진섭 안 on 11. 9. 18..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "CameraViewController.h"
#import "OverlayViewController.h"

@implementation CameraViewController

@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [_overlay release];
    [_imageView release];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*) iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Camera";
}

+ (BOOL) isEnableDevice
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


#pragma mark - event handler

-(IBAction) onTakePicture
{

    
#if 1
    //
    // UIImagePickerController을 이용하는 방법
    //
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    // 사진을 찍고 수정할 수 있도록.
    picker.allowsEditing = NO;
    
    // 카메라 이용.
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;    
    //// 이미 찍어놓은 사진 중에서 선택
    //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
    //// iTunes와 동기화한 사진들 중에서 선택.
    //picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
#endif

#if 0  
    //
    // UIImagePickerController를 이용한 Custom View 사용방법.
    //
    
    // overlay 생성
    if (_overlay == nil) {
        _overlay = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    // 카메라 이용.
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;    
    picker.showsCameraControls = NO;
    picker.cameraOverlayView = _overlay.view;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
#endif

}

#pragma mark - UIImagePickerControllerDelegate handler

// 이미지를 찍었을때 호출되는 함수.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissModalViewControllerAnimated:YES];
    
    self.imageView.image = [image copy];
    
}
// 이미지 촬영을 취소 했을때 호출되는 함수
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

@end
