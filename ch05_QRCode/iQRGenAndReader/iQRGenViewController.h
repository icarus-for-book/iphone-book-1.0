//
//  iQRGenViewController.h
//  iQRGenAndReader
//
//  Created by parkinhye on 11. 6. 29..
//  Copyright 2011 sss. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyViewBarcode.h"

@interface iQRGenViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate> {
    
    NSMutableArray *dataSourceArray;
    UITableView *genTableView;
    
    UIImageView *imageView;
    UIImage *image;
    UILabel *dataLabel, *qrResultLabel;
    
    BOOL isKeyPressed;
    
    NSString *linkAddrData;
}

@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) IBOutlet UITableView *genTableView;
@property BOOL isKeyPressed;
@property (nonatomic, retain) NSString *linkAddrData;

- (IBAction) genBackBtnClicked;     //BackButton 클릭시 메인화면으로 돌아감
- (IBAction) showBarcodeImage: (id) sender;

@end
