//
//  AddCommentViewController.h
//  iPicasaWebViewer
//
//  Created by jinni on 11. 7. 1..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingView;
@class AddCommentViewController;

@protocol AddCommentViewControllerDelegate <NSObject>

- (void) addCommentViewControllerDidUpdated:(AddCommentViewController*)commentView;

@end

@interface AddCommentViewController : UIViewController {
    LoadingView *_loadingView;
}
@property(nonatomic, retain) LoadingView *loadingView;

@property(nonatomic, assign) id <AddCommentViewControllerDelegate> delegate;
@property(nonatomic, retain) GDataServiceGooglePhotos *googlePhotoService;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) PhotoInfo *photo;

@property(nonatomic, retain) IBOutlet UITextView *textView;

@end
