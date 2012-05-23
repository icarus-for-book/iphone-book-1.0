//
//  AccelerometerViewController.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 9. 14..
//  Copyright 2011년 ICARUS. All rights reserved.
//

#import "AccelerometerViewController.h"

static const NSUInteger kMaxDataPoints = 20;
static NSString * kPlotXRate    = @"X";
static NSString * kPlotYRate    = @"Y";
static NSString * kPlotZRate    = @"Z";


@interface AccelerometerViewController()

@property(nonatomic, retain) UIAccelerometer *accelerometer;

- (void) enableAccelermeter:(BOOL)flag;
// char에 표시할 Data추가
- (void) addPlotData:(NSDictionary*) data;
// chart를 초기화
- (void) renderChart;

@end

@implementation AccelerometerViewController
@synthesize labelX = _labelX;
@synthesize labelY = _labelY;
@synthesize labelZ = _labelZ;
@synthesize graphHostingView = _graphHostingView;

@synthesize accelerometer=_accelerometer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _plotData = [[NSMutableArray alloc] initWithCapacity:kMaxDataPoints];
    }
    return self;
}

-(void)dealloc
{
    [_plotData release];
    [_accelerometer release];
    [_graphHostingView release];
    [_labelX release];
    [_labelY release];
    [_labelZ release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLabelX:nil];
    [self setLabelY:nil];
    [self setLabelZ:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [self renderChart];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableAccelermeter:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self enableAccelermeter:NO];
}


#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[AccelerometerViewController alloc] initWithNibName:@"AccelerometerViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*) iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Accelerometer";
}

+ (BOOL) isEnableDevice
{
    return YES;
}

#pragma mark - UIAccelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    self.labelX.text = [NSString stringWithFormat:@"%.1f", acceleration.x];   
    self.labelY.text = [NSString stringWithFormat:@"%.1f", acceleration.y];
    self.labelZ.text = [NSString stringWithFormat:@"%.1f", acceleration.z];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithFloat:acceleration.x], @"x",
                         [NSNumber numberWithFloat:acceleration.y], @"y",
                         [NSNumber numberWithFloat:acceleration.z], @"z",
                         nil];
    
    [self addPlotData:dic];
}

#pragma mark - private method

- (void) enableAccelermeter:(BOOL)flag
{
    if (flag)
    {
        // turn on
        self.accelerometer = [UIAccelerometer sharedAccelerometer];
        self.accelerometer.updateInterval = 0.1f; // update in 0.1 second.
        self.accelerometer.delegate = self;
        
    } else
    {
        // turn off
        self.accelerometer.delegate = nil;
    }
    
}

- (void) renderChart
{
    CGRect bounds = self.graphHostingView.bounds;
    CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:bounds] autorelease];
    self.graphHostingView.hostedGraph = graph;
    
    // set graph
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    // set padding
    float boundsPadding = round(bounds.size.width / 20.0f); // Ensure that padding falls on an integral pixel
    graph.paddingLeft = boundsPadding;
    graph.paddingTop = boundsPadding;
    graph.paddingRight = boundsPadding;
    graph.paddingBottom = boundsPadding; 
    
    // set plot area
    graph.plotAreaFrame.paddingTop = 15.0;
	graph.plotAreaFrame.paddingRight = 15.0;
	graph.plotAreaFrame.paddingBottom = 15.0;
	graph.plotAreaFrame.paddingLeft = 10.0;
	
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
	
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];    
	
	// Axes
    // X axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
	
    // Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyEqualDivisions;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
	y.minorTicksPerInterval = 1;
    y.labelOffset = 4.0f;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	
    // Create the plot
    
    // X
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = kPlotXRate;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 3.0;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Y
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = kPlotYRate;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 3.0;
    lineStyle.lineColor = [CPTColor redColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    
    // Z
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = kPlotZRate;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 3.0;
    lineStyle.lineColor = [CPTColor blueColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
	
	// Plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(kMaxDataPoints - 1)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-3) length:CPTDecimalFromUnsignedInteger(6)];    
}

- (void) addPlotData:(NSDictionary*) data
{
    // plot range 조정
    CPTGraph *theGraph = self.graphHostingView.hostedGraph;
    CPTPlot *thePlotX = [theGraph plotWithIdentifier:kPlotXRate];
    CPTPlot *thePlotY = [theGraph plotWithIdentifier:kPlotYRate];
    CPTPlot *thePlotZ = [theGraph plotWithIdentifier:kPlotZRate];
    
    if ( thePlotX ) {
        if ( _plotData.count >= kMaxDataPoints ) {
            [_plotData removeObjectAtIndex:0];
            [thePlotX deleteDataInIndexRange:NSMakeRange(0, 1)];
            [thePlotY deleteDataInIndexRange:NSMakeRange(0, 1)];
            [thePlotZ deleteDataInIndexRange:NSMakeRange(0, 1)];
        }
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)theGraph.defaultPlotSpace;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(_currentIndex >= kMaxDataPoints ? _currentIndex - kMaxDataPoints + 1: 0)
                                                        length:CPTDecimalFromUnsignedInteger(kMaxDataPoints - 1)];
        
        _currentIndex++;
        [_plotData addObject:data];
        [thePlotX insertDataAtIndex:_plotData.count - 1 numberOfRecords:1];
        [thePlotY insertDataAtIndex:_plotData.count - 1 numberOfRecords:1];
        [thePlotZ insertDataAtIndex:_plotData.count - 1 numberOfRecords:1];
        
    }
    
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _plotData.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num = nil;
    NSDictionary *data = [_plotData objectAtIndex:index];
	
	switch ( fieldEnum ) {
		case CPTScatterPlotFieldX:
			num = [NSNumber numberWithUnsignedInteger:index + _currentIndex - _plotData.count];
			break;
			
		case CPTScatterPlotFieldY:
            if (plot.identifier == kPlotXRate) {
                num = [data objectForKey:@"x"];
            } else if (plot.identifier == kPlotYRate) {
                num = [data objectForKey:@"y"];
            } else if (plot.identifier == kPlotZRate) {
                num = [data objectForKey:@"z"];
            }
			break;
			
		default:
			break;
	}
	
    return num;
}
@end
