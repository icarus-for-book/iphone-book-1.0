//
//  StorageInfoViewController.m
//  DeviceInfoControl
//
//  Created by  on 11. 8. 7..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "StorageInfoViewController.h"
#import "StorageInfo.h"

@interface StorageInfoViewController()

@property(nonatomic, retain) StorageInfo *storageInfo;

- (void) setupPieChart;

@end

@implementation StorageInfoViewController
@synthesize totalSize;
@synthesize usedSize;
@synthesize freeSize;
@synthesize storageInfo;
@synthesize graphHostingView=_graphHostingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        storageInfo = [[StorageInfo alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_chart release];
    [_graphHostingView release];
    [storageInfo release];
    [totalSize release];
    [usedSize release];
    [freeSize release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalSize.text = [NSString stringWithFormat:@"%.2f", self.storageInfo.totalSize / 1024.0f /1024.0f];
    self.usedSize.text = [NSString stringWithFormat:@"%.2f", self.storageInfo.usedSize / 1024.0f /1024.0f];
    self.freeSize.text = [NSString stringWithFormat:@"%.2f", self.storageInfo.freeSize / 1024.0f /1024.0f];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupPieChart];
}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[StorageInfoViewController alloc] initWithNibName:@"StorageInfoViewController" bundle:nil];
    return [ret autorelease];
}

+ (UIImage*)   iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"storage";
}

+ (BOOL) isEnableDevice
{
    return YES;
}

- (void) setupPieChart
{
    [_chart release];
	
    // Create pieChart from theme
    _chart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [_chart applyTheme:theme];
    self.graphHostingView.hostedGraph = _chart;
	
    _chart.paddingLeft = 20.0;
	_chart.paddingTop = 20.0;
	_chart.paddingRight = 20.0;
	_chart.paddingBottom = 20.0;
	
	_chart.axisSet = nil;
	
	CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
	
    // Add pie chart
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource = self;
	piePlot.pieRadius = 60.0;
    piePlot.identifier = @"Pie Chart 1";
	piePlot.startAngle = M_PI_4;
	piePlot.sliceDirection = CPTPieDirectionCounterClockwise;
	piePlot.centerAnchor = CGPointMake(0.5, 0.5f);
	piePlot.borderLineStyle = [CPTLineStyle lineStyle];
	piePlot.delegate = self;
    [_chart addPlot:piePlot];
    [piePlot release];
}

#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 2;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	if ( index >= 2 ) return nil;
	
	if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
        if (index == 0) {
            // 사용한 메모리.
            return [NSNumber numberWithFloat:(float)self.storageInfo.usedSize / self.storageInfo.totalSize];
        } else
        {
            // Free 메모리
            return [NSNumber numberWithFloat:(float)self.storageInfo.freeSize / self.storageInfo.totalSize];
        }
	}
	else {
		return [NSNumber numberWithInt:index];
	}
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
    NSString *title = @"";
    if (index == 0) {
        title = @"Used";
    } else {
        title = @"Free";
    }
    
	CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:title];
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
	textStyle.color = [CPTColor lightGrayColor];
    textStyle.fontSize = 18;
    label.textStyle = textStyle;
    [textStyle release];
	return [label autorelease];
}

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)piePlot recordIndex:(NSUInteger)index
{
	CGFloat offset = 0.0;
	
	if ( index == 0 ) {
		offset = piePlot.pieRadius / 20.0;
	}
	
    return offset;
}



@end
