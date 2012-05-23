
#import <Foundation/Foundation.h>

#import "OBGlobal.h"
#import "OBWBarcodeUtils.h"
#import "OBWIBarcode.h"

@interface OBBarcodeUtils : NSObject {

}

+ (int) getBarcodeInnerUOM: (OB_UNIT_OF_MEASURE) uom;

+ (int) getBarcodeInnerRotate: (OB_ROTATE) rotate;

+ (int) convertDPI2PPC: (int) dpi;

+ (float) getSizeFrom: (OB_UNIT_OF_MEASURE) from to: (OB_UNIT_OF_MEASURE) to size: (float) size resolution: (int) resolution allow0: (BOOL) allow0;

+ (int) getSizePixelfromCM: (int) resolution sizeCM: (float) sizeCM allow0: (BOOL) allow0;

+ (int) getSizePixelfromInch: (int) resolution sizeInch: (float) sizeInch allow0: (BOOL) allow0;

+ (float) getSizeCM: (int) resolution sizePixel: (int) sizePixel;

@end
