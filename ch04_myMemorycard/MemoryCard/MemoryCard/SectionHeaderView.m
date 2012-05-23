#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation SectionHeaderView


@synthesize titleLabel, disclosureButton, delegate, section;

-(id)initWithFrame:(CGRect)frame 
             title:(NSString*)title 
           section:(NSInteger)sectionNumber 
          delegate:(id <SectionHeaderViewDelegate>)aDelegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];

        delegate = aDelegate;        
        self.userInteractionEnabled = YES;
        
        // add background image
        UIImageView *backgroudImage = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroudImage.image = [UIImage imageNamed:@"common_main_list_view_mainplate_back.png"];
        [self addSubview:backgroudImage];
        [backgroudImage release];
        
        
        // Create and configure the title label.
        section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 15.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        
        // Create and configure the disclosure button.]
        disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(270.0, 15.0, 14.0, 14.0);
        [disclosureButton setImage:[UIImage imageNamed:@"common_main_list_view_mainplate_icon_arrow.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"common_main_list_view_mainplate_icon_arrow.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}

-(void) animateDisclosure
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    CGFloat rotationDegree = (self.disclosureButton.selected) ? 90.0f : 0.0f;

    disclosureButton.transform = CGAffineTransformMakeRotation(degreesToRadian(rotationDegree));
    
    [UIView commitAnimations];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    disclosureButton.selected = !disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (disclosureButton.selected) {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [delegate sectionHeaderView:self sectionOpened:section];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [delegate sectionHeaderView:self sectionClosed:section];
            }
        }
    }
    
    // 접혔는지 표시하는 > 버튼을 회전 시킨다.
    [self animateDisclosure];

}


- (void)dealloc {
    
    [titleLabel release];
    [disclosureButton release];
    [super dealloc];
}


@end
