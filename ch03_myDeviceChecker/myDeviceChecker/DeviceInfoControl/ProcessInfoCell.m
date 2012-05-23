//
//  ProcessInfoCell.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 12..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "ProcessInfoCell.h"

@implementation ProcessInfoCell

@synthesize processName=_processName;
@synthesize processId=_processId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) dealloc
{
    [_processId release];
    [_processName release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
