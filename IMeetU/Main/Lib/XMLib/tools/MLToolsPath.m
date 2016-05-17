//
//  MLToolsPath.m
//  MeetU
//
//  Created by zhanghao on 15/10/7.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "MLToolsPath.h"

@implementation MLToolsPath

+ (NSString *)pathDocuments{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)pathDocumentsWithFileName:(NSString *)fileName{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
}

+ (NSString *)pathLibraryCaches{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
}

+ (NSString *)pathLibraryCachesWithFileName:(NSString *)fileName{
    return [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:fileName];
}

+ (NSString *)pathLibraryPreferences{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Preferences"];
}

+ (NSString *)pathLibraryPreferencesWithFileName:(NSString *)fileName{
    return [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:fileName];
}

+ (NSString *)pathLibraryPrivateDocuments{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Private Documents"];
}

+ (NSString *)pathLibraryPrivateDocumentsWithFileName:(NSString *)fileName{
    return [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Private Documents"] stringByAppendingPathComponent:fileName];
}

+ (NSString *)pathTmp{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

+ (NSString *)pathTmpWithFileName:(NSString *)fileName{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:fileName];
}

+ (void)test{
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathDocuments]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathDocumentsWithFileName:@"me.h"]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathLibraryCaches]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathLibraryCachesWithFileName:@"me.h"]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathLibraryPreferences]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathLibraryPreferencesWithFileName:@"me.h"]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathLibraryPrivateDocuments]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathLibraryPrivateDocumentsWithFileName:@"me.h"]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathTmp]);
    
    NSLog(@"\n");
    NSLog(@"%@", [MLToolsPath pathTmpWithFileName:@"me.h"]);
}

@end
