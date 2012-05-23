//
//  Utility.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 27..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"


@implementation Utility


// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// create new UUID
+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

+ (NSDate*) lastModifiedDateForPath:(NSString*) path
{
    if ( path == nil ) return nil;
    
    NSError * err;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDictionary * fileattr = [fileManager attributesOfItemAtPath:path error:&err];
    if (fileattr == nil) {
        NSLog(@"error %@", err);
        return nil;
    }
    
    NSDate * date = [fileattr objectForKey:@"NSFileModificationDate"];
    return date;
}

@end
