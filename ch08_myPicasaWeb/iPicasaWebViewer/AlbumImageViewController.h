//
//  AlbumImageViewController.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumImageCellView.h"
#import "RefreshTableHeaderView.h"

@class AlbumImageCellView;
@class GroupingPhotos;

@interface AlbumImageViewController : UITableViewController    <UITableViewDataSource,
                                                                NSFetchedResultsControllerDelegate,
                                                                AlbumImageCellViewDelegate> 
{
                                                                 
    // VIEW
    RefreshTableHeaderView *refreshHeaderView;
    AlbumImageCellView *_tableCell;
                                                                 
    // MODEL
    BOOL checkForRefresh;
    BOOL reloading;
    AlbumInfo *_albumInfo;
    
    GDataServiceGooglePhotos *_googlePhotoService;
    NSManagedObjectContext *_managedObjectContext;
    
    GDataServiceTicket  *_photoFetchTicket;
    NSError             *_photoFetchError;
    GDataFeedPhotoAlbum *_photoFeed;
    
    GroupingPhotos *_groupingPhotos;
    
}

@property(nonatomic, retain) AlbumInfo *albumInfo;
@property(nonatomic, retain) GDataServiceGooglePhotos *googlePhotoService;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) GDataServiceTicket  *photoFetchTicket;
@property(nonatomic, retain) NSError             *photoFetchError;
@property(nonatomic, retain) GDataFeedPhotoAlbum *photoFeed;
@property(nonatomic, retain) IBOutlet AlbumImageCellView *tableCell;
@property(nonatomic, retain) GroupingPhotos *groupingPhotos;

@end
