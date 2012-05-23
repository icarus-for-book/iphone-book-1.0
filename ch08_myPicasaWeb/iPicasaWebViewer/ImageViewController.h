//
//  ImageViewController.h
//  iPicasaWebViewer
//
//  Created by jinni on 11. 6. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RepositoryManager;
@class ImageScrollView;


@interface ImageViewController : UIViewController {
    NSArray *_photos;
    PhotoInfo *_currentPhoto;
    
    ImageScrollView *_imageView;
    UILabel     *_textTitle;
    
    UIActivityIndicatorView *_loadingIndicator;
    
    RepositoryManager *_repository;
    
    GDataServiceGooglePhotos *_googlePhotoService;
    NSManagedObjectContext *_managedObjectContext;
    
    GDataServiceTicket  *_photoFetchTicket;
    NSError             *_photoFetchError;
    GDataFeedPhotoAlbum *_photoFeed;
    
    // View
    UIBarButtonItem *_buttonPrev;
    UIBarButtonItem *_buttonNext;
    UIBarButtonItem *_buttonSlide;
    
    // Model
    
    // Controller
}

@property(nonatomic, retain) NSArray *photos;
@property(nonatomic, retain) PhotoInfo *currentPhoto;

@property(nonatomic, retain) IBOutlet ImageScrollView *imageView;
@property(nonatomic, retain) IBOutlet UILabel     *textTitle;

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property(nonatomic, retain) GDataServiceGooglePhotos *googlePhotoService;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) GDataServiceTicket  *photoFetchTicket;
@property(nonatomic, retain) NSError             *photoFetchError;
@property(nonatomic, retain) GDataFeedPhotoAlbum *photoFeed;


@property(nonatomic, retain) IBOutlet UIBarButtonItem *buttonPrev;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *buttonNext;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *buttonSlide;

- (IBAction) clickAction:(id)sender;
- (IBAction) clickShowPrev:(id)sender;
- (IBAction) clickShowNext:(id)sender;
- (IBAction) clickSlideToggle:(id)sender;
- (IBAction) clickShowComment:(id)sender;

@end
