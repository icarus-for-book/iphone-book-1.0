//
//  AccountInfo.h
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 26..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlbumInfo;

@interface AccountInfo : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * passwd;
@property (nonatomic, retain) NSSet* albums;

@end
