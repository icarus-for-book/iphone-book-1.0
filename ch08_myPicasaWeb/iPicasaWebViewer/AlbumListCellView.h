//
//  AlbumListCellView.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"


// AlbumListViewController에서 사용할 
// Custom Table Cell

@interface AlbumListCellView : UITableViewCell 
    
@property (nonatomic, retain) UILabel *textTitle;
@property (nonatomic, retain) UIImageView *imageThumb;
@property (nonatomic, assign) AccessLevel accessLevel;
@property (nonatomic, retain) UIImageView *accessLevelImageView;
@property (nonatomic, retain) UILabel *textSubtitle;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;

@end 
