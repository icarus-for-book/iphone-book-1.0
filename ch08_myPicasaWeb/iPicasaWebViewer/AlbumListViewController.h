//
//  AlbumListViewController.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableHeaderView.h"

@class AccountInfo;
@class AlbumListCellView;
@class RepositoryManager;

@interface AlbumListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>{
    // View
    RefreshTableHeaderView *refreshHeaderView;
    AlbumListCellView *_tableCell;

    // Control
    UISearchDisplayController *_searchController;
    
    // Model
    BOOL checkForRefresh;
    BOOL reloading;
    BOOL _searchIsActive;
    
    NSArray *_filteredArray;
    
    AccountInfo *_accountInfo;
    GDataServiceGooglePhotos *_googlePhotoService;
    NSManagedObjectContext *_managedObjectContext;
    NSFetchedResultsController *__fetchedResultsController;
    
    GDataServiceTicket *_albumFetchTicket;
    NSError            *_albumFetchError;
    GDataFeedPhotoUser *_albumFeed;
    
    
    RepositoryManager *_repositoryManager;
    
    
}
@property(nonatomic,retain) UISearchDisplayController *searchController;
@property(nonatomic,retain) NSArray *filteredArray;
@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain) AccountInfo *accountInfo;
@property(nonatomic,retain) GDataServiceGooglePhotos *googlePhotoService;
@property(nonatomic,retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,assign) BOOL searchIsActive;
@property(nonatomic,assign) IBOutlet AlbumListCellView *tableCell;

- (void)dataSourceDidFinishLoadingNewData;
- (void) showReloadAnimationAnimated:(BOOL)animated;

@end
