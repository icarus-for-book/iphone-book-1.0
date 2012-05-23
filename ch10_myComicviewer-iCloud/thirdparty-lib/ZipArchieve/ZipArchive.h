//
//  ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//
// History: 
//    09-11-2008 version 1.0    release
//    10-18-2009 version 1.1    support password protected zip files
//    10-21-2009 version 1.2    fix date bug


#include "minizip/zip.h"
#include "minizip/unzip.h"


@protocol ZipArchiveDelegate <NSObject>
@optional
-(void) ErrorMessage:(NSString*) msg;
-(BOOL) OverWriteOperation:(NSString*) file;
@end

// UnzipFileList에서 반환할 Entry 값.
@interface ZipEntry : NSObject <NSCoding> {
@private
    // 파일이름 
    NSString* filename;
    // index in zipfile
    NSInteger zipIndex;
}

@property (nonatomic, retain) NSString* filename;
@property (nonatomic, assign) NSInteger zipIndex;

@end


@interface ZipArchive : NSObject {
@private
	zipFile		_zipFile;
	unzFile		_unzFile;
	
	NSString*   _password;
	id			_delegate;
}

@property (nonatomic, retain) id delegate;

-(BOOL) CreateZipFile2:(NSString*) zipFile;
-(BOOL) CreateZipFile2:(NSString*) zipFile Password:(NSString*) password;
-(BOOL) addFileToZip:(NSString*) file newname:(NSString*) newname;
-(BOOL) CloseZipFile2;

-(BOOL) UnzipOpenFile:(NSString*) zipFile;
-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password;
-(BOOL) UnzipFileTo:(NSString*)path overWrite:(BOOL) overwrite;
-(NSArray*) UnzipFileList:(NSArray*)extentions;
-(NSData*) UnzipDataOfIndex:(NSInteger)index;
-(BOOL) UnzipFileTo:(NSString*)path ofIndex:(NSInteger)index overWrite:(BOOL) overwrite;
-(BOOL) UnzipCloseFile;
@end
