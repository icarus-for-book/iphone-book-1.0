
#import "OBGlobal.h"

#import <Foundation/Foundation.h>

#import "OBLinear.h"

@interface OBEnumUtil : NSObject

+ (OB_BARCODE_TYPE) parseBarcodeType: (NSString *) strType;

+ (OB_UNIT_OF_MEASURE) parseUnitOfMeasure: (NSString *) strUOM defaultUOM: (OB_UNIT_OF_MEASURE) defaultUOM;

+ (OB_ROTATE) parseRotate: (NSString *) strRotate defaultRotate: (OB_ROTATE) defaultRotate;

@end
