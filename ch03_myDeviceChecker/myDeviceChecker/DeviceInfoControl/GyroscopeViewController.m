
#import "GyroscopeViewController.h"
#import <CoreMotion/CoreMotion.h>

static const NSUInteger kMaxDataPoints = 20;
NSString * kPlotRoll    = @"Roll";
NSString * kPlotPitch   = @"Pitch";
NSString * kPlotYaw     = @"Yaw";

#define PI 3.14159265358979323846
static inline float degrees(double radian) { return radian * 180.0f / PI; }

@interface PlotDataPosition : NSObject
{
    CGFloat roll;
    CGFloat pitch;
    CGFloat yaw;
}

@property(nonatomic, assign) CGFloat roll;
@property(nonatomic, assign) CGFloat pitch;
@property(nonatomic, assign) CGFloat yaw;


- (id) initWithRoll:(CGFloat) roll pitch:(CGFloat)pitch yaw:(CGFloat)yaw;

@end

@implementation PlotDataPosition

@synthesize roll;
@synthesize pitch;
@synthesize yaw;

- (id) initWithRoll:(CGFloat)_roll pitch:(CGFloat)_pitch yaw:(CGFloat)_yaw
{
    if (self = [super init]) {
        roll = _roll;
        pitch = _pitch;
        yaw = _yaw;
    }
    return self;
}

@end

// private APIs
@interface GyroscopeViewController()

@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, retain) CMMotionManager *motionManager;

// enable gyroscope
- (void) enableGyro:(BOOL) flag;
// 기지의 현재 자세헤 대한 그래프
- (void) renderPositionStatus;

- (void) addPlotDataPosition:(PlotDataPosition*) data;

@end

@implementation GyroscopeViewController

@synthesize updateTimer = _updateTimer;
@synthesize graphHostingView=_graphHostingView;
@synthesize motionManager=_motionManager;
@synthesize gyroRoll=_gyroRoll;
@synthesize gyroPitch=_gyroPitch;
@synthesize gyroYaw=_gyroYaw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Motion manager 객체 생성
        _motionManager = [[CMMotionManager alloc] init];
        _plotDataForPosition = [[NSMutableArray alloc] initWithCapacity:kMaxDataPoints];
        _currentIndex = 0;
    }
    return self;
}

-(void)dealloc
{
    [_graphHostingView release];
    [_gyroRoll release];
    [_gyroPitch release];
    [_gyroYaw release];
    [_updateTimer release];
    [_motionManager release];
    [_plotDataForPosition release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [self renderPositionStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableGyro:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self enableGyro:NO];
}

#pragma mark - DeviceViewItem protocol

+ (id) createViewItem
{
    id ret = [[GyroscopeViewController alloc] initWithNibName:@"GyroscopeViewController" bundle:nil];
    
    return [ret autorelease];
}

+ (UIImage*) iconImage
{
    return [UIImage imageNamed:@"memory.png"];
}

+ (NSString*)  title
{
    return @"Gyroscope";
}

+ (BOOL) isEnableDevice
{
    id cls = NSClassFromString(@"CMMotionManager");
    if (cls == nil) return NO;
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    BOOL ret = motionManager.gyroAvailable;
    [motionManager release];
    return ret;
}


#pragma mark - private methods

-(void) enableGyro:(BOOL) flag
{
    if (flag == YES) {
        
        // 0.3초다 마다 업데이트
        _motionManager.deviceMotionUpdateInterval = 0.3;
        // 자이로스코프 시작.
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] 
                                            withHandler:^(CMDeviceMotion *motion, NSError *error) 
        {
            // 실제 XYZ 기울기 값을 구해보자.
            CMAttitude *attitude = motion.attitude;
            self.gyroRoll.text = [NSString stringWithFormat:@"%.0f", degrees(attitude.roll)];
            self.gyroPitch.text = [NSString stringWithFormat:@"%.0f", degrees(attitude.pitch)];
            self.gyroYaw.text = [NSString stringWithFormat:@"%.0f", degrees(attitude.yaw)];
            
            // 챠트에 표시할 Data 생성 및 추가
            PlotDataPosition *posData = [[PlotDataPosition alloc] initWithRoll:degrees(attitude.roll) 
                                                                         pitch:degrees(attitude.pitch)
                                                                           yaw:degrees(attitude.yaw)];
            [self addPlotDataPosition:posData];
            [posData release];
            
        }];
        
    } else 
    {
        [_motionManager stopDeviceMotionUpdates];
    }

}

- (void) renderPositionStatus
{
    // 호스트 뷰에 챠트 그래프 뷰를 생성해서 붙인다.
    CGRect bounds = self.graphHostingView.bounds;
    CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:bounds] autorelease];
    self.graphHostingView.hostedGraph = graph;
    
    // 테마 생성
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];

    // 그래프뷰의 패딩 설정
    float boundsPadding = round(bounds.size.width / 20.0f); // Ensure that padding falls on an integral pixel
    graph.paddingLeft = boundsPadding;
    graph.paddingTop = boundsPadding;
    graph.paddingRight = boundsPadding;
    graph.paddingBottom = boundsPadding; 
    
    // 그래프뷰에 그릴 Plot 뷰 설정
    graph.plotAreaFrame.paddingTop = 15.0;
	graph.plotAreaFrame.paddingRight = 15.0;
	graph.plotAreaFrame.paddingBottom = 15.0;
	graph.plotAreaFrame.paddingLeft = 15.0;
	
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
	
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];    
	
	// Axes
    // X축 설정
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
	x.labelingPolicy = CPTAxisLabelingPolicyEqualDivisions;
    x.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
	
    // Y축 설정
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyEqualDivisions;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
	y.minorTicksPerInterval = 30;
    y.labelOffset = 60.0f;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	
    // 데이터를 나타낼 Plot생성 ( 3개의 그래프를 나타내야 하므로 3개를 생성)
    
    // roll
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = kPlotRoll;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 3.0;
    lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // pitch
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = kPlotPitch;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 3.0;
    lineStyle.lineColor = [CPTColor redColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    
    // yaw
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = kPlotYaw;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 3.0;
    lineStyle.lineColor = [CPTColor blueColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
	
	// Plot을 표현할 영역을 표시.
	// X축은 0에서 데이터가 가질 수 있는 영역까지
	// Y축은  -180도 ~ 180도
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(kMaxDataPoints - 1)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-180) length:CPTDecimalFromUnsignedInteger(360)];    
}

- (void) addPlotDataPosition:(PlotDataPosition*) data
{
    // plot range 조정
    CPTGraph *theGraph = self.graphHostingView.hostedGraph;
    CPTPlot *thePlotRoll = [theGraph plotWithIdentifier:kPlotRoll];
    CPTPlot *thePlotPitch = [theGraph plotWithIdentifier:kPlotPitch];
    CPTPlot *thePlotYaw = [theGraph plotWithIdentifier:kPlotYaw];
    
    if ( thePlotRoll ) {
        if ( _plotDataForPosition.count >= kMaxDataPoints ) {
            [_plotDataForPosition removeObjectAtIndex:0];
            [thePlotRoll deleteDataInIndexRange:NSMakeRange(0, 1)];
            [thePlotPitch deleteDataInIndexRange:NSMakeRange(0, 1)];
            [thePlotYaw deleteDataInIndexRange:NSMakeRange(0, 1)];
        }
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)theGraph.defaultPlotSpace;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(_currentIndex >= kMaxDataPoints ? _currentIndex - kMaxDataPoints + 1: 0)
                                                        length:CPTDecimalFromUnsignedInteger(kMaxDataPoints - 1)];
        
        _currentIndex++;
        [_plotDataForPosition addObject:data];
        [thePlotRoll insertDataAtIndex:_plotDataForPosition.count - 1 numberOfRecords:1];
        [thePlotPitch insertDataAtIndex:_plotDataForPosition.count - 1 numberOfRecords:1];
        [thePlotYaw insertDataAtIndex:_plotDataForPosition.count - 1 numberOfRecords:1];
        
    }
    
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _plotDataForPosition.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num = nil;
    PlotDataPosition *data = [_plotDataForPosition objectAtIndex:index];
	
	switch ( fieldEnum ) {
		case CPTScatterPlotFieldX:
			num = [NSNumber numberWithUnsignedInteger:index + _currentIndex - _plotDataForPosition.count];
			break;
			
		case CPTScatterPlotFieldY:
            if (plot.identifier == kPlotRoll) {
                num = [NSNumber numberWithFloat:data.roll];
            } else if (plot.identifier == kPlotPitch) {
                num = [NSNumber numberWithFloat:data.pitch];
            } else if (plot.identifier == kPlotYaw) {
                num = [NSNumber numberWithFloat:data.yaw];
            }
			break;
			
		default:
			break;
	}
	
    return num;
}

@end
