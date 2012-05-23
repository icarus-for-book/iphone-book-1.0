//
//  CominInfo.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 24..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicInfo.h"
#import "ZipArchive.h"
#import "Utility.h"


@implementation ComicInfo

@synthesize path, lastModified, files, lastPage, lastAccess;

- (id) init
{
    self = [super init];
    
    return self;
}

- (void) dealloc
{
    [lastAccess release];
    [path release];
    [lastModified release];
    [files release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.lastModified forKey:@"modifiedDate"];
    [aCoder encodeObject:self.files forKey:@"files"];
    [aCoder encodeInteger:lastPage forKey:@"lastPage"];
    [aCoder encodeObject:lastAccess forKey:@"lastAccess"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.path = [aDecoder decodeObjectForKey:@"path"];
    self.lastModified = [aDecoder decodeObjectForKey:@"modifiedDate"];
    self.files = [aDecoder decodeObjectForKey:@"files"];
    self.lastPage = [aDecoder decodeIntegerForKey:@"lastPage"];
    self.lastAccess = [aDecoder decodeObjectForKey:@"lastAccess"];
    return self;
}

// 책을 잆은 정보를 반환.
// 1. 책을 첫 페이지를 읽고 있으면 읽지 않은 상태이므로 kComicBookReadNotYet,
// 2. 마지막 페이지를 보고 있다면 kComicBookReadDone
// 3. 위의 두경우가 아니면 읽고 있는 중을 나타내는 kComicBookReading
// 을 각각 반환한다. 
- (ComicBookStatus) readStatus
{
    if (self.lastPage == 0) {
        return kComicBookReadNotYet;
    } 
    
    if ([self.files count] > 0 && 
        self.lastPage == [self.files count] - 1) {
        return kComicBookReadDone;
    }
    
    return kComicBookReading;
}

// 만화 파일(Zip파일)에서 원하는 이미지의 Data를 가져온다.
- (NSData*) imageFilePathAt:(NSInteger)index
{
    NSData *retImage = nil;
    ZipEntry* zipEntry = [self.files objectAtIndex:self.lastPage];
    ZipArchive* za = [[ZipArchive alloc] init];
    if([za UnzipOpenFile:self.path])
    {
        retImage = [za UnzipDataOfIndex:zipEntry.zipIndex];
        [za UnzipCloseFile];
    }
    [za release];
    
    return retImage;
}

- (CGFloat) percentForRead
{
    return 100.0f * (self.lastPage + 1) / self.files.count;
}

- (BOOL) isEqualComic:(NSString*) filepath
{
    NSDate *newModifiedDate = [Utility lastModifiedDateForPath:filepath];
    
    if ( ! [self.lastModified isEqualToDate:newModifiedDate]) {
        return NO;
    }
    
    return YES;
}




@end
