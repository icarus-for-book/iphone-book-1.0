
#import "OBGlobal.h"

#import <Foundation/Foundation.h>
#ifdef PLATFORM_MAC_OS_X
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

#import "OBBarcodeUtils.h"
#import "OBWIBarcode.h"

@interface OBLinear : NSObject {
@private
	OB_BARCODE_TYPE nBarcodeType;
	NSString *pDataMsg;
	BOOL bAddCheckSum;
	
	//	Bar Size:
	OB_UNIT_OF_MEASURE uom;
	float fX;
	float fY;
	float fLeftMargin;
	float fRightMargin;
	float fTopMargin;
	float fBottomMargin;
	int nResolution;
	OB_ROTATE nRotate;
	float fBarcodeWidth;
	float fBarcodeHeight;
	
	//	Text Style
	BOOL bShowText;
	BOOL bShowCheckSumChar;
#ifndef PLATFORM_MAC_OS_X
	UIFont *pTextFont;
#else
	NSFont *pTextFont;
#endif
	float fTextMargin;
	
	//	General
	
	
	//	ean, upc, issn, isbn supplement data related
	NSString *pSupData;
	float fSupHeight;
	float fSupSpace;
	
	//	for code 39, and ITF14 (_n only)
	float fI;
	float fN;
	BOOL bShowStartStopInText;
	
	//	for ITF14
	float fBearerBarHori;
	float fBearerBarVert;
	
	//	for code128
	BOOL bProcessTilde;
	
	int nApplicationIndicator;
	
	//	for codabar
	OB_CODABAR_START_STOP_CHAR nCodabarStartChar;
	OB_CODABAR_START_STOP_CHAR nCodabarStopChar;
	
	//	for postnet, planet
	
	
	
	
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

@property (readwrite) OB_BARCODE_TYPE nBarcodeType;
@property (retain) NSString *pDataMsg;
@property (readwrite) BOOL bAddCheckSum;
//	Bar Size:
@property OB_UNIT_OF_MEASURE uom;
@property float fX;
@property float fY;
@property float fLeftMargin;
@property float fRightMargin;
@property float fTopMargin;
@property float fBottomMargin;
@property int nResolution;
@property OB_ROTATE nRotate;
@property float fBarcodeWidth;
@property float fBarcodeHeight;
//	Text Style
@property BOOL bShowText;
@property BOOL bShowCheckSumChar;
#ifndef PLATFORM_MAC_OS_X
@property (assign) UIFont *pTextFont;
#else
@property (assign) NSFont *pTextFont;
#endif
@property float fTextMargin;
//	General
//	ean, upc, issn, isbn supplement data related
@property (retain) NSString *pSupData;
@property float fSupHeight;
@property float fSupSpace;
//	for code 39, and ITF14 (_n only)
@property float fI;
@property float fN;
@property BOOL bShowStartStopInText;
//	for ITF14
@property float fBearerBarHori;
@property float fBearerBarVert;
//	for code128
@property BOOL bProcessTilde;

@property int nApplicationIndicator;

//	for codabar
@property OB_CODABAR_START_STOP_CHAR nCodabarStartChar;
@property OB_CODABAR_START_STOP_CHAR nCodabarStopChar;

//	for postnet, planet




//@property (retain) OBWBarcodeSymbologyInner *pBarcodeInner;
//@property (retain) OBWIBarcode *pBarcodeInner;

@property (readonly) int nResultBarcodeWidthInPixel;
@property (readonly) int nResultBarcodeHeightInPixel;

@end
