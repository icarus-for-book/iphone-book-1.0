//
//  AlbumImageCellView.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 26..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumImageCellView;

@protocol AlbumImageCellViewDelegate <NSObject>

- (void)albumImageCell:(AlbumImageCellView*)cellView didClicked:(NSInteger) index;

@end

@interface AlbumImageCellView : UITableViewCell {
    UIImageView *_image1;
    UIImageView *_image2;
    UIImageView *_image3;
    UIActivityIndicatorView *_loadingIndicator1;
    UIActivityIndicatorView *_loadingIndicator2;
    UIActivityIndicatorView *_loadingIndicator3;
    id<AlbumImageCellViewDelegate> _delegate;
}

@property(nonatomic, retain) IBOutlet UIImageView *image1;
@property(nonatomic, retain) IBOutlet UIImageView *image2;
@property(nonatomic, retain) IBOutlet UIImageView *image3;

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator1;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator2;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator3;

@property(nonatomic, assign) id<AlbumImageCellViewDelegate> delegate;

@end
