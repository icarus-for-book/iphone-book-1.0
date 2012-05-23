#import "ItemCellView.h"

@implementation ItemCellView

@synthesize titleLabel;



- (void)dealloc {
    
    [titleLabel release];
    [super dealloc];   
}

@end

