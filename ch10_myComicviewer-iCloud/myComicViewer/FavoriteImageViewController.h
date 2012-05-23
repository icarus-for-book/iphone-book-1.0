//
//  FavoriteImageViewController.h
//  myComicViewer
//

#import <UIKit/UIKit.h>
#import "FavoriteDocument.h"
#import "ImageScrollView.h"

@interface FavoriteImageViewController : UIViewController

@property (retain, nonatomic) IBOutlet ImageScrollView *imageScrollView;
@property (retain, nonatomic) FavoriteDocument *document;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
