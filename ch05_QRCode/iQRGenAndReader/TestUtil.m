
#import "TestUtil.h"

#import "OBGlobal.h"
#import "OBLinear.h"
#import "OBDataMatrix.h"
#import "OBQRCode.h"

@interface TestUtil (Private)

- (void) testAllWithView: (UIView *) view;

- (void) testCodabarWithView: (UIView *) view;

- (void) testCode11WithView: (UIView *) view;

- (void) testInterleaved25WithView: (UIView *) view;

- (void) testITF14WithView: (UIView *) view;

- (void) testCode39WithView: (UIView *) view;

- (void) testUPCAWithView: (UIView *) view;

- (void) testUPCEWithView: (UIView *) view;

- (void) testEAN13WithView: (UIView *) view;

- (void) testEAN8WithView: (UIView *) view;

- (void) testCode128WithView: (UIView *) view;

- (void) testDataMatrixWithView: (UIView *) view;

- (void) testQRCodeWithView: (UIView *) view;

- (void) setLinearBarcodeDimension: (OBLinear *) pLinear;

@end

@implementation TestUtil

@synthesize inputQRData;

#define USER_DEF_LEFT_MARGIN	0.0f
#define USER_DEF_RIGHT_MARGIN	0.0f
#define USER_DEF_TOP_MARGIN		0.0f
#define USER_DEF_BOTTOM_MARGIN	0.0f

#define USER_DEF_BAR_WIDTH			5.0f//2.0f
#define USER_DEF_BAR_HEIGHT			90.0f
#define USER_DEF_BARCODE_WIDTH		0.0f
#define USER_DEF_BARCODE_HEIGHT		0.0f

#define USER_DEF_ROTATION		(0)

- (id) initWithQRData:(NSString *)str {
    self = [super init];
    if (self) {
        self.inputQRData = [NSString stringWithFormat:@"%@", str];
    }
    
    return self;
}

- (void) test: (UIView *)view
{
	//[self testAllWithView: view];
	//[self testCodabarWithView: view];
	//[self testCode11WithView: view];
	//[self testInterleaved25WithView: view];
	//[self testITF14WithView: view];
	//[self testCode39WithView: view];
    //[self testUPCAWithView: view];      //barcode 용
	//[self testUPCEWithView: view];
	//[self testEAN13WithView: view];
	//[self testEAN8WithView: view];

	//[self testCode128WithView: view];	
    //[self testDataMatrixWithView: view];
    
	[self testQRCodeWithView: view];
}

@end

@implementation TestUtil (Private)

- (void) testAllWithView: (UIView *) view
{
	[self testCodabarWithView: view];
	[self testCode11WithView: view];
	[self testInterleaved25WithView: view];
	[self testITF14WithView: view];
	[self testCode39WithView: view];
	[self testUPCAWithView: view];
	[self testUPCEWithView: view];
	[self testEAN13WithView: view];
	[self testEAN8WithView: view];
	
	[self testCode128WithView: view];

	[self testDataMatrixWithView: view];
	[self testQRCodeWithView: view];	
}

- (void) testCodabarWithView: (UIView *) view
{	
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_CODABAR];
	NSString *pMsg = [[NSString alloc] initWithString: (@"123")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];

	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	//	Code to draw to UIImage
	//UIImage *tempImage = nil;
	//[pLinear drawWithImage: (UIImage **)(&tempImage)];
	
	//	Code to get Barcode Width and Height in pixels
	//NSLog(@"Barcode Width: %d", [pLinear nResultBarcodeWidthInPixel]);
	//NSLog(@"Barcode Height: %d", [pLinear nResultBarcodeHeightInPixel]);
	//NSLog(@"UIImage Width: %f", [tempImage size].width);
	//NSLog(@"UIImage Height: %f", [tempImage size].height);
	
	[pLinear release];
	[pMsg release];
	
	//[tempImage drawInRect: CGRectMake(0, 0, [tempImage size].width, [tempImage size].height)];
}

- (void) testCode11WithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_CODE11];
	NSString *pMsg = [[NSString alloc] initWithString: (@"123")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];

	[pLinear release];
	[pMsg release];
}

- (void) testInterleaved25WithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_INTERLEAVED25];
	NSString *pMsg = [[NSString alloc] initWithString: (@"123")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
}

- (void) testITF14WithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_ITF14];
	NSString *pMsg = [[NSString alloc] initWithString: (@"1234567890123")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
}

- (void) testCode39WithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_CODE39];
	NSString *pMsg = [[NSString alloc] initWithString: (@"12345")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
}

- (void) testUPCAWithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_UPCA];
	NSString *pMsg = [[NSString alloc] initWithString: (@"12345678901")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
}

- (void) testUPCEWithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_UPCE_2];
	NSString *pMsg = [[NSString alloc] initWithString: (@"123456")];
	[pLinear setPDataMsg: pMsg];
	
	NSString *pSMsg = [[NSString alloc] initWithString: (@"32")];
	[pLinear setPSupData: pSMsg];	
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
	[pSMsg release];
}

- (void) testEAN13WithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_EAN13];
	NSString *pMsg = [[NSString alloc] initWithString: (@"123456789012")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
}

- (void) testEAN8WithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_EAN8_5];
	NSString *pMsg = [[NSString alloc] initWithString: (@"1234567")];
	[pLinear setPDataMsg: pMsg];
	
	NSString *pSMsg = [[NSString alloc] initWithString: (@"12345")];
	[pLinear setPSupData: pSMsg];	
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
	[pSMsg release];
}

- (void) testCode128WithView: (UIView *) view
{
	OBLinear *pLinear = [OBLinear new];
	[pLinear setNBarcodeType: OB_EAN128];
	NSString *pMsg = [[NSString alloc] initWithString: (@"(10)12345")];
	[pLinear setPDataMsg: pMsg];
	
	[self setLinearBarcodeDimension: pLinear];
	
	CGRect printArea = CGRectMake(10.0, 20.0, 300.0, 200.0);
	[pLinear drawWithView: (view) rect: &printArea alignHCenter: TRUE];
	
	[pLinear release];
	[pMsg release];
}




- (void) testDataMatrixWithView: (UIView *) view
{
	NSAutoreleasePool *pPool = [[NSAutoreleasePool alloc] init];
	
	OBDataMatrix *pDataMatrix = [OBDataMatrix new];
	//[pDataMatrix setNDataMode: OB_DATAMATRIX_ASCII];
	[pDataMatrix setNDataMode: OB_DATAMATRIX_Auto];
	[pDataMatrix setBProcessTilde: (FALSE)];
	
	NSString *pMsg = [[NSString alloc] initWithString: (@"123")];
	[pDataMatrix setPData: pMsg];
	//[pDataMatrix setPData: [[NSString alloc] initWithString: (@"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-={}[]<>?,./")]];
	[pDataMatrix setFX: USER_DEF_BAR_WIDTH];
	
	[pDataMatrix setNFormatMode: (OB_DATAMATRIX_Format_64X64)];
	
	[pDataMatrix setBStructuredAppend: (FALSE)];
	[pDataMatrix setNSymbolCount: (10)];
	[pDataMatrix setNSymbolIndex: (0)];
	[pDataMatrix setNFileId: (102)];
	
	
	
	//[pDataMatrix drawWithView: (self)];
	
	CGRect printArea = CGRectMake(10.0, 240.0, 300.0, 200.0);
	[pDataMatrix drawWithView: (view) rect: &printArea];
	
	[pDataMatrix release];
	[pMsg release];
	
	[pPool release];
}

- (void) testQRCodeWithView: (UIView *) view
{
	NSAutoreleasePool *pPool = [[NSAutoreleasePool alloc] init];
	
	OBQRCode *pQRCode = [OBQRCode new];
//	[pQRCode setNDataMode: OB_QRCODE_AlphaNumeric];
    [pQRCode setNDataMode: OB_QRCODE_Auto];
	[pQRCode setBProcessTilde: (FALSE)];
	
    NSString *pMsg = [[NSString alloc] initWithString: self.inputQRData];
	[pQRCode setPData: pMsg];
	//[pQRCode setPData: [[NSString alloc] initWithString: (@"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-={}[]<>?,./")]];
	[pQRCode setFX: USER_DEF_BAR_WIDTH];
	
	[pQRCode setNVersion: (OB_QRCODE_V1)];
	[pQRCode setNECL: (OB_QRCODE_L)];
	
	[pQRCode setBStructuredAppend: (FALSE)];
	[pQRCode setNSymbolCount: (10)];
	[pQRCode setNSymbolIndex: (0)];
	
	[pQRCode setFLeftMargin: USER_DEF_LEFT_MARGIN];
	[pQRCode setFRightMargin: USER_DEF_RIGHT_MARGIN];
	[pQRCode setFTopMargin: USER_DEF_TOP_MARGIN];
	[pQRCode setFBottomMargin: USER_DEF_BOTTOM_MARGIN];
	
	//[pQRCode setNRotate: (OB_Rotate0)];
	[pQRCode setNRotate: (USER_DEF_ROTATION)];
	//[pQRCode setNRotate: (OB_Rotate180)];
	//[pQRCode setNRotate: (OB_Rotate270)];
	
	//[pQRCode drawWithView: (self)];
	
	CGRect printArea = CGRectMake(60, 60, 200.0, 200.0);
	[pQRCode drawWithView: (view) rect: &printArea];
	
	[pQRCode release];
	[pMsg release];
	
	[pPool release];
}

- (void) setLinearBarcodeDimension: (OBLinear *) pLinear;
{
	[pLinear setFX: USER_DEF_BAR_WIDTH];
	[pLinear setFY: USER_DEF_BAR_HEIGHT];
	[pLinear setFBarcodeWidth: USER_DEF_BARCODE_WIDTH];
	[pLinear setFBarcodeHeight: USER_DEF_BARCODE_HEIGHT];
	
	[pLinear setFLeftMargin: USER_DEF_LEFT_MARGIN];
	[pLinear setFRightMargin: USER_DEF_RIGHT_MARGIN];
	[pLinear setFTopMargin: USER_DEF_TOP_MARGIN];
	[pLinear setFBottomMargin: USER_DEF_BOTTOM_MARGIN];
	
	[pLinear setNRotate: (USER_DEF_ROTATION)];
	
	UIFont *pTextFont = [UIFont fontWithName: @"Arial" size: 8.0f];
	[pLinear setPTextFont: pTextFont];
}

- (void)dealloc {
    
    [inputQRData release];
    [super dealloc];
}

@end
