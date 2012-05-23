
#import "OBGlobal.h"

#import <Foundation/Foundation.h>
#ifdef PLATFORM_MAC_OS_X
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

#import "OBBarcodeUtils.h"
#import "OBWIBarcode.h"

@interface OBQRCode : NSObject {
@private
	NSString *pData;
	BOOL bProcessTilde;
	
	OB_QRCODE_DATA_MODE nDataMode;
	OB_QRCODE_ECL nECL;
	//Extended Channel Interpretation
	int nECI;
	OB_FNC1 nFnc1;
	int nApplicationIndicator;
	
	BOOL bStructuredAppend;
	int nSymbolCount;
	int nSymbolIndex;
	
	int nParity;
	OB_QRCODE_VERSION nVersion;  //from v1 - v40, auto
	
	//private ImageFormat _imageFormat;
	
	//size
	OB_UNIT_OF_MEASURE uom;
	float fX;
	float fLeftMargin;
	float fRightMargin;
	float fTopMargin;
	float fBottomMargin;
	int nResolution;
	OB_ROTATE nRotate;
	float fBarcodeWidth;
	float fBarcodeHeight;
	
	// internal use only
	//OBWBarcodeSymbologyInner *pBarcodeInner;
	OBWIBarcode *pBarcodeInner;
	
	int nResultBarcodeWidthInPixel;
	int nResultBarcodeHeightInPixel;
}

//	For Mac OS X
#ifdef	PLATFORM_MAC_OS_X
- (void) drawWithView: (NSView *) view;

- (void) drawWithView: (NSView *) view rect: (CGRect *) rect;

- (void) drawWithFile: (NSString *) fileName;

- (void) drawWithContext: (CGContextRef) context;
//	For iPhone
#else
- (void) drawWithView: (UIView *) view;

- (void) drawWithView: (UIView *) view alignHCenter: (BOOL) alignHCenter;

- (void) drawWithView: (UIView *) view rect: (CGRect *) rect;

- (void) drawWithView: (UIView *) view rect: (CGRect *) rect alignHCenter: (BOOL) alignHCenter;

- (void) drawWithImage: (UIImage **) image;
#endif

@property (retain) NSString *pData;
@property BOOL bProcessTilde;
@property OB_QRCODE_DATA_MODE nDataMode;
@property OB_QRCODE_ECL nECL;
@property int nECI;
@property OB_FNC1 nFnc1;
@property int nApplicationIndicator;
@property BOOL bStructuredAppend;
@property int nSymbolCount;
@property int nSymbolIndex;
@property int nParity;
@property OB_QRCODE_VERSION nVersion;
@property OB_UNIT_OF_MEASURE uom;
@property float fX;
@property float fLeftMargin;
@property float fRightMargin;
@property float fTopMargin;
@property float fBottomMargin;
@property int nResolution;
@property OB_ROTATE nRotate;
@property float fBarcodeWidth;
@property float fBarcodeHeight;
//@synthesize imageFormat;

@property (readonly) int nResultBarcodeWidthInPixel;
@property (readonly) int nResultBarcodeHeightInPixel;

@end
