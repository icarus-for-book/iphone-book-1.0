//
//  MyViewBarcode.m
//  OnBarcodeIPhoneClient
//
//  Created by Wang Qi on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyViewBarcode.h"

#import "TestUtil.h"

@implementation MyViewBarcode

@synthesize qrData;

#define USER_DEF_LEFT_MARGIN	60.0f
#define USER_DEF_RIGHT_MARGIN	20.0f
#define USER_DEF_TOP_MARGIN		30.0f
#define USER_DEF_BOTTOM_MARGIN	10.0f

#define USER_DEF_BAR_WIDTH		1.0f
#define USER_DEF_BAR_HEIGHT		80.0f


- (id)initWithFrame:(CGRect)frame qrData:(NSString *)mQrData {

    self = [self initWithFrame:frame];
    if(self != nil) {
        self.qrData = [NSString stringWithFormat:@"%@", mQrData];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        // Initialization code
		self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect: (CGRect)rect {
    
    // Drawing code
    TestUtil *pTest = [[TestUtil alloc]initWithQRData:self.qrData];
    
	[pTest test: (self)];
    
	[pTest release];
}

- (void)dealloc {
    [qrData release];
    [super dealloc];
}

@end