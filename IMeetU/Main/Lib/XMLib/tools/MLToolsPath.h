//
//  MLToolsPath.h
//  MeetU
//
//  Created by zhanghao on 15/10/7.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLToolsPath : NSObject

+ (NSString*)pathDocuments;

+ (NSString*)pathDocumentsWithFileName:(NSString*)fileName;

+ (NSString*)pathLibraryCaches;

+ (NSString*)pathLibraryCachesWithFileName:(NSString*)fileName;

+ (NSString*)pathLibraryPreferences;

+ (NSString*)pathLibraryPreferencesWithFileName:(NSString*)fileName;

+ (NSString*)pathLibraryPrivateDocuments;

+ (NSString*)pathLibraryPrivateDocumentsWithFileName:(NSString*)fileName;

+ (NSString*)pathTmp;

+ (NSString *)pathTmpWithFileName:(NSString*)fileName;


+ (void)test;
@end
