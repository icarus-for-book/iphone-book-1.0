//
//  AlbumListCellView.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlbumListCellView.h"


@implementation AlbumListCellView

@synthesize textTitle=_textTitle;
@synthesize imageThumb=_imageThumb;
@synthesize accessLevel=_accessLevel;
@synthesize accessLevelImageView=_accessLevelImageView;
@synthesize textSubtitle=_textSubtitle;
@synthesize loadingIndicator=_loadingIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)dealloc
{
    [_loadingIndicator release];
    [_textTitle release];
    [_imageThumb release];
    [_accessLevelImageView release];
    [_textSubtitle release];
    [super dealloc];
}

- (void) setAccessLevel:(AccessLevel)level
{
    _accessLevel = level;
    
    switch (level) {
        case kAccessLevelPrivate:
            self.accessLevelImageView.image = [UIImage imageNamed:@"private.png"];
            break;
        case kAccessLevelProtected:
            self.accessLevelImageView.image = [UIImage imageNamed:@"protected.png"];
            break;
        case kAccessLevelPublic:
        default:
            self.accessLevelImageView.image = [UIImage imageNamed:@"public.png"];
            break;
    }
    
}


@end
