//
//  DBCache.m
//  MeetU
//
//  Created by zhanghao on 15/10/15.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "DBCache.h"
#import "FMDatabase.h"
#import "MLToolsPath.h"

@interface DBCache()

@end
@implementation DBCache

+ (instancetype)shareInstance{
    static DBCache *DBFactory;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        DBFactory = [[DBCache alloc] init];
    });
    
    return DBFactory;
}

+ (NSString *)getDBPath{
    //NSLog(@"DBPath====>%@", [MLToolsPath pathDocumentsWithFileName:@""]);
    return [MLToolsPath pathDocumentsWithFileName:@"IU.sqlite"];
}

- (FMDatabase *)db{
    if (!_db) {
        NSString *dbPath = [DBCache getDBPath];
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    return _db;
}

@end
