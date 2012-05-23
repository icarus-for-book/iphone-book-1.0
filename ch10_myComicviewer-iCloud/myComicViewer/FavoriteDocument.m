//
//  FavoriteDocument.m
//  myComicViewer
//

#import "FavoriteDocument.h"

@implementation FavoriteDocument

@synthesize image;

- (void)dealloc
{
    [image release];
    [super dealloc];
}

// 데이터 읽기
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    if([contents length] > 0){
        UIImage *img = [UIImage imageWithData:contents];
        self.image = img;
    } else {
        self.image = nil;
    }
    
    return YES;
}

// 데이터 쓰기
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    
    NSData *data = UIImageJPEGRepresentation(self.image, 0.6f);
    
    NSLog(@"data size = %d", data.length);
    
    if (self.image) {
        return data;
    } else {
        return [[[NSData alloc] init] autorelease];
    }
}


@end
