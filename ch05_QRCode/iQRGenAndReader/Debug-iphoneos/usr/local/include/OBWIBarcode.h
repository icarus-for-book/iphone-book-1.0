
#import "OBWGlobal.h"

#import <Foundation/Foundation.h>
#ifdef PLATFORM_MAC_OS_X
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

//	Enum - Barcode Type
extern int const OBW_SPEC_CODABAR;
extern int const OBW_SPEC_CODE11;
extern int const OBW_SPEC_CODE2OF5;
extern int const OBW_SPEC_CODE39;
extern int const OBW_SPEC_CODE39EX;
extern int const OBW_SPEC_CODE93;
extern int const OBW_SPEC_EAN8;
extern int const OBW_SPEC_EAN8_2;
extern int const OBW_SPEC_EAN8_5;
extern int const OBW_SPEC_EAN13;
extern int const OBW_SPEC_EAN13_2;
extern int const OBW_SPEC_EAN13_5;
extern int const OBW_SPEC_ISBN;
extern int const OBW_SPEC_ISBN_5;
extern int const OBW_SPEC_ISSN;
extern int const OBW_SPEC_ISSN_2;
extern int const OBW_SPEC_ITF14;
extern int const OBW_SPEC_INTERLEAVED25;
extern int const OBW_SPEC_CODE128;
extern int const OBW_SPEC_CODE128A;
extern int const OBW_SPEC_CODE128B;
extern int const OBW_SPEC_CODE128C;
extern int const OBW_SPEC_EAN128;
extern int const OBW_SPEC_UPCA;
extern int const OBW_SPEC_UPCA_2;
extern int const OBW_SPEC_UPCA_5;
extern int const OBW_SPEC_UPCE;
extern int const OBW_SPEC_UPCE_2;
extern int const OBW_SPEC_UPCE_5;
extern int const OBW_SPEC_ISBN_2;
extern int const OBW_SPEC_ISSN_5;
extern int const OBW_SPEC_PDF417;
extern int const OBW_SPEC_DATAMATRIX;
extern int const OBW_SPEC_QRCODE;

//	Enum - Direction
extern int const OBW_ANGLE_0;
extern int const OBW_ANGLE_90;
extern int const OBW_ANGLE_180;
extern int const OBW_ANGLE_270;

//	Enum - Bearer Bar Type
extern int const OBW_BEARERBAR_UNSPECIFIED;
extern int const OBW_BEARERBAR_NONE;
extern int const OBW_BEARERBAR_FRAME;
extern int const OBW_BEARERBAR_TOPBOTTOM;

//	Enum - Quiet Zone Type
extern int const OBW_QUIETZONE_UNSPECIFIED;
extern int const OBW_QUIETZONE_NONE;
extern int const OBW_QUIETZONE_ROUND;
extern int const OBW_QUIETZONE_LEFTRIGHT;

//	Enum - Construct Error Code
extern int const OBW_ERR_NONE;
extern int const OBW_ERR_UNACCEPTABLE_CHARACTER;
extern int const OBW_ERR_INVALID_DATA_LENGTH;
extern int const OBW_ERR_INVALID_DATA_INPUT;
extern int const OBW_ERR_INVALID_DIMENSION_CFG;
extern int const OBW_ERR_INVALID_BARCODE_DIMENSION_INPUT;
extern int const OBW_ERR_DATA_ENCODE_FAILED;
extern int const OBW_ERR_NO_VALID_SPEC;
extern int const OBW_ERR_UNSUPPORT_IMAGE_FORMAT;
extern int const OBW_ERR_PRINT_IMAGE_FAILED;
extern int const OBW_ERR_UNDEFINED;

//  Enum - ECI
extern int const OBW_ECI_UNSPECIFIED;
extern int const OBW_ECI_MAX_VALUE;
extern int const OBW_ECI_DEFAULT;    //  000003

//  Enum - FNC1
extern int const OBW_FNC1_NONE;
extern int const OBW_FNC1_1ST_POS;
extern int const OBW_FNC1_2ND_POS;

@interface OBWIBarcode : NSObject

#ifdef PLATFORM_MAC_OS_X
- (BOOL) renderBarcodeWithFile: (NSString *) imageFile;

- (BOOL) renderBarcodeWithView: (NSView *) view;

- (BOOL) renderBarcodeWithContext: (CGContextRef) context;
#else
- (int) renderBarcodeWithView: (UIView *) view boundary: (CGRect *) rect alignHCenter: (BOOL) alignHCenter;

- (int) renderBarcodeWithImage: (UIImage **) image;

//	Abandoned
//- (BOOL) renderBarcodeWithContext: (CGContextRef) context view: (UIView *) view;
#endif

@end
