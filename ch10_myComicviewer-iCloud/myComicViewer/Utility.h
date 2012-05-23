//
//  Utility.h
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 27..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject {
    
}

// Document Path를 반환.
+ (NSURL *)applicationDocumentsDirectory;

// Create UUID
+ (NSString *)GetUUID;

// 파일의 last modified time 구함. 
+ (NSDate*) lastModifiedDateForPath:(NSString*) path;
@end
