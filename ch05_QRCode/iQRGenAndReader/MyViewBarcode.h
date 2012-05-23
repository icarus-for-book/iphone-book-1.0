//
//  MyViewBarcode.h
//  OnBarcodeIPhoneClient
//
//  Created by Wang Qi on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewBarcode : UIView {
    NSString *qrData;
}

@property (nonatomic, retain) NSString *qrData;

- (id)initWithFrame:(CGRect)frame qrData:(NSString *)mQrData;

@end
