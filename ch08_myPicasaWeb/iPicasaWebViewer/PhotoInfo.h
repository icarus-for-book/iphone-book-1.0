//
//  PhotoInfo.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 7. 7..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlbumInfo;

@interface PhotoInfo : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * photoid;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSString * camera;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * iso;
@property (nonatomic, retain) NSString * exposure;
@property (nonatomic, retain) NSString * aperture;
@property (nonatomic, retain) NSString * focalLength;
@property (nonatomic, retain) NSNumber * flashUsed;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSDate * originalTime;
@property (nonatomic, retain) AlbumInfo * album;

@end
