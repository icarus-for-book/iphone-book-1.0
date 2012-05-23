
#import "OBGlobal.h"

#import <Foundation/Foundation.h>
#ifdef PLATFORM_MAC_OS_X
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

#import "OBBarcodeUtils.h"
//#import "OBWBarcodeSymbologyInner.h"
#import "OBWIBarcode.h"

@interface OBDataMatrix : NSObject {
@private
	NSString *pData;
	BOOL bProcessTilde;
	
	int nDataMode;
	int nFormatMode;
	
	int nFnc1;
	int nApplicationIndicator;
	BOOL bStructuredAppend;
	int nSymbolCount;
	int nSymbolIndex;
	int nFileId;
	
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
@property int nDataMode;
@property int nFormatMode;
@property int nFnc1;
@property int nApplicationIndicator;
@property BOOL bStructuredAppend;
@property int nSymbolCount;
@property int nSymbolIndex;
@property int nFileId;
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
