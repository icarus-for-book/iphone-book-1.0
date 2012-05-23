//
//  PieChart.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 9. 15..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "PieChart.h"

#pragma mark - pieData

@interface PieData : NSObject
{
    UIColor *color;
    CGFloat  percent;
}

@property(nonatomic, retain) UIColor *color;
@property(nonatomic, assign) CGFloat percent;

@end

@implementation PieData
@synthesize color;
@synthesize percent;
@end

#pragma mark - PieChart private metheds
@interface PieChart()
@property (nonatomic, retain) NSMutableArray *datas;
@end


#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }


@implementation PieChart

@synthesize datas = _datas;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _datas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) awakeFromNib
{
    _datas = [[NSMutableArray alloc] init];
}

- (void) dealloc
{
    [_datas release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    
	CGRect parentViewBounds = self.bounds;
	CGFloat x = CGRectGetWidth(parentViewBounds)/2;
	CGFloat y = CGRectGetHeight(parentViewBounds)/2;
    CGFloat r = MIN(x,y) * 0.9;
    
    
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextClearRect(ctx, rect);
    
	// define stroke color
	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
    
	// define line width
	CGContextSetLineWidth(ctx, 4.0);
    
    // need some values to draw pie charts
    CGFloat start = 0.0f;
    for (PieData* data in self.datas)
    {
        CGContextSetFillColor(ctx, CGColorGetComponents( [data.color CGColor] ));
        CGContextMoveToPoint(ctx, x, y);     
        CGContextAddArc(ctx, x, y, r,  radians(start), radians(start+data.percent * 360.0f), 0); 
        CGContextClosePath(ctx); 
        CGContextFillPath(ctx); 
        
        start += data.percent * 360.0f;
    }
}

- (void) addPercent:(CGFloat)data color:(UIColor*)color;
{
    PieData *piedata = [[PieData alloc] init];
    piedata.percent = data;
    piedata.color = color;
    [self.datas addObject:piedata];
    [piedata release];
}

- (void)clearData
{
    [self.datas removeAllObjects];
}


@end
