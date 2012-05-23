//
//  main.m
//  guguquiz
//
//  Created by Jinsub Ahn on 11. 11. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 
    // 구구단을 디버깅 콘솔에 출력하기 
    int i, j;
    for (i = 1; i < 10; i++) {
        for (j = 1; j < 10; j++) {
            NSLog(@"%d x %d = %d \n", i, j, i*j);
        }
    }
        
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
