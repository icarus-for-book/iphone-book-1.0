
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestUtil : NSObject {
    NSString *inputQRData;
}

@property (nonatomic, retain)  NSString *inputQRData;

- (id) initWithQRData:(NSString *)str;
- (void) test: (UIView *) view;

@end
