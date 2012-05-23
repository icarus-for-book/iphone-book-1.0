//
//  iQRReaderViewController.h
//  iQRGenAndReader
//
//  Created by parkinhye on 11. 6. 29..
//  Copyright 2011 sss. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

@interface iQRReaderViewController : UIViewController <ZBarReaderDelegate, UIActionSheetDelegate> {
    
    UITableView *readerTableView;
    NSMutableArray *dataSourceArray;
    
    UIImageView *imageView;
    UILabel *typeLabel, *dataLabel;

    BOOL found, paused;
    NSInteger dataHeight;
}

@property (nonatomic, retain) IBOutlet UITableView *readerTableView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;

- (IBAction) scanButtonClicked;
- (IBAction) readBackBtnClicked;    //BackButton 클릭시 메인화면으로 돌아감

@end
