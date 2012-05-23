//
//  PicasawebService.m
//  iPicasaWebViewer
//
//  Created by 진섭 안 on 11. 6. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PicasawebService.h"
#import "GData.h"

@implementation PicasawebService

- (id) initWithId:(NSString*)username
           passwd:(NSString*)passwd
{
    
    self = [super init];
    if(self)
    {
        googleService = [[GDataServiceGooglePhotos alloc] init];
        
        [googleService setShouldCacheResponseData:YES];
        [googleService setServiceShouldFollowNextLinks:YES];
        if ([username length] && [passwd length]) {
            [googleService setUserCredentialsWithUsername:username
                                           password:passwd];
        } else {
            [googleService setUserCredentialsWithUsername:nil
                                           password:nil];
        }
    }
    
    return self;
}

@end
