//
//  AlbumImageCellView.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 26..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlbumImageCellView.h"


@implementation AlbumImageCellView

@synthesize image1=_image1;
@synthesize image2=_image2;
@synthesize image3=_image3;
@synthesize loadingIndicator1 = _loadingIndicator1;
@synthesize loadingIndicator2 = _loadingIndicator2;
@synthesize loadingIndicator3 = _loadingIndicator3;
@synthesize delegate = _delegate;



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
    [_image1 release];
    [_image2 release];
    [_image3 release];
    [_loadingIndicator1 release];
    [_loadingIndicator2 release];
    [_loadingIndicator3 release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:recognizer];
    [recognizer release];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    NSLog(@"setSelected");
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
    
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
       NSLog(@"%s", __FUNCTION__); 
}

- (void)drawRect:(CGRect)dirtyRect
{
    
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer 
{
    
    CGPoint curPos = [recognizer locationInView:self];
    
    if(CGRectContainsPoint(self.image1.frame,curPos))
    {
        if(_delegate){
            [_delegate albumImageCell:self didClicked:1];
        }
    }
    if(CGRectContainsPoint(self.image2.frame,curPos))
    {
        if(_delegate){
            [_delegate albumImageCell:self didClicked:2];
        }
    }
    if(CGRectContainsPoint(self.image3.frame,curPos))
    {
        if(_delegate){
            [_delegate albumImageCell:self didClicked:3];
        }
    }
    
}


@end
