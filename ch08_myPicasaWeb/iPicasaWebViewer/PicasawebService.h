//
//  PicasawebService.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataServiceGooglePhotos.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"

@interface PicasawebService : NSObject {
    GDataServiceGooglePhotos *googleService;
}

- (id) initWithId:(NSString*)username
           passwd:(NSString*)passwd;



@end
