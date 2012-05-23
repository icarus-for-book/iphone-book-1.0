
#import <Foundation/Foundation.h>

extern int const OBW_UNIT_OF_MEASURE_PIXEL;
extern int const OBW_UNIT_OF_MEASURE_CM;
extern int const OBW_UNIT_OF_MEASURE_INCH;

@interface OBWBarcodeUtils : NSObject {
}

+ (int) convertDPI2PPCInt: (int) dpi;

+ (float) convertDPI2PPCFloat: (float) dpi;

+ (int) convertPPC2DPIInt: (int) ppc;

+ (float) convertPPC2DPIFloat: (float) ppc;

+ (float) getSizeFromUnit: (int) srcUnit toUnit: (int) desUnit
				 withSize: (float) sizeVal withResolution: (int) resolution
				allowZero: (BOOL) allowZeroFlag;

+ (int) getSizePixelfromPixelWith: (float) pixel allowZero: (BOOL) allowFlag;

+ (int) getSizePixelfromCMWith: (float) sizeCM withResolution: (int) resolution
					 allowZero: (BOOL) allowFlag;

+ (int) getSizePixelfromInchWith: (float) sizeInch withResolution: (int) resolution
					   allowZero: (BOOL) allowFlag;

+ (float) getSizeCMfromPixelWith: (int) sizePixel withResolution: (int) resolution;

+ (float) getSizeInchfromPixelWith: (int) sizePixel withResolution: (int) resolution;

@end
