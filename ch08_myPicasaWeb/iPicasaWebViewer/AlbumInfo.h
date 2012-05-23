//
//  AlbumInfo.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 26..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccountInfo, PhotoInfo;

@interface AlbumInfo : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * access;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSDate * published;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * caching;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * albumid;
@property (nonatomic, retain) NSNumber * numOfPhotos;
@property (nonatomic, retain) AccountInfo * account;
@property (nonatomic, retain) NSSet* photos;

@end
