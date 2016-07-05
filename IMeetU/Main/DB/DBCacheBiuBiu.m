//
//  DBCacheBiuBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "DBCacheBiuBiu.h"
#import "FMDB.h"
#import "ModelUserMatch.h"

@implementation DBCacheBiuBiu

+ (instancetype)shareInstance{
    static DBCacheBiuBiu *dao;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DBCacheBiuBiu alloc] init];
    });
    return dao;
}

- (instancetype)init{
    if (self = [super init]) {
        [self creatTable];
    }
    return self;
}

- (void)creatTable{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table  if not exists %@(user_code INTEGER PRIMARY KEY, name_nick TEXT, age INTEGER, gender INTEGER, profile_url TEXT, constellation TEXT, school_id INTEGER, time_biu_send INTEGER, is_show BOOL)", self.tableName];
        [self.db executeUpdate:sql];
        [self.db close];
    }
}

- (void)cleanDB{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@", self.tableName];
        [self.db executeUpdate:sql];
        [self.db close];
    }
}

- (NSInteger)selectCountOfUnShow{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select COUNT(*) from %@ where is_show=0", self.tableName];
        FMResultSet *set = [self.db executeQuery:sql];
        if (set.next) {
            return [set longForColumnIndex:0];
        }
        [self.db close];
    }
    return 0;
}
- (ModelUserMatch *)selectLatestAndUnShow{
    ModelUserMatch *model = nil;
    
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select *from %@ where is_show=0 order by time_biu_send DESC limit 1", self.tableName];
        FMResultSet *set = [self.db executeQuery:sql];
        if (set.next) {
            model = [self modelWithSet:set];
        }
        [self.db close];
    }
    
    return model;
}

- (ModelUserMatch *)selectLastBiu{
    ModelUserMatch *model = nil;
    
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select *from %@ order by time_biu_send limit 1", self.tableName];
        FMResultSet *set = [self.db executeQuery:sql];
        if (set.next) {
            model = [self modelWithSet:set];
        }
        [self.db close];
    }
    
    return model;
}


- (void)insertWithModelUserMatch:(ModelUserMatch*)model{
    if ([self.db open]) {
        [self justInsertWithModelUserMatch:model];
        [self.db close];
    }
}
- (void)insertWithArrModelUserMatch:(NSArray*)models{
   
    if ([self.db open]) {
        for (ModelUserMatch *model in models) {
            [self justInsertWithModelUserMatch:model];
        }
        [self.db close];
    }
}
- (void)justInsertWithModelUserMatch:(ModelUserMatch*)model{
    NSString *sql = [NSString stringWithFormat:@"insert or replace into %@ (user_code, name_nick, age, gender, profile_url, constellation, school_id, time_biu_send, is_show)values(?,?,?,?,?,?,?,?,?)", self.tableName];
    
    [self.db executeUpdate:sql, [NSNumber numberWithInteger:model.userCode], model.nameNick, [NSNumber numberWithInteger:model.age], [NSNumber numberWithInteger:model.gender], model.urlProfileThumbnail, model.constellation, [NSNumber numberWithInteger:model.schoolID], [NSNumber numberWithInteger:model.timeSendBiu], [NSNumber numberWithBool:NO]];
}

- (void)updateHaveBeenShownWithUserCode:(NSInteger)userCode{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set is_show=1 where user_code=?", self.tableName];
        [self.db executeUpdate:sql, [NSNumber numberWithInteger:userCode]];
        [self.db close];
    }
}

- (void)updateAllSetUnShow{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set is_show=0", self.tableName];
        [self.db executeUpdate:sql];
        [self.db close];
    }
}

- (BOOL)haveBiuWithUserCode:(NSInteger)userCode{
    BOOL result = NO;
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select user_code from %@ where user_code=? limit 1", self.tableName];
        FMResultSet *set = [self.db executeQuery:sql, [NSNumber numberWithInteger:userCode]];
        result = set.next;
        
        [self.db close];
    }
    return  result;
}

- (void)deleteWithUserCode:(NSInteger)userCode{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where user_code=?", self.tableName];
        [self.db executeUpdate:sql, [NSNumber numberWithInteger:userCode]];
        
        [self.db close];
    }
}

- (ModelUserMatch*)modelWithSet:(FMResultSet*)set{
    ModelUserMatch *model = [[ModelUserMatch alloc] init];
    model.userCode = [set longForColumn:@"user_code"];
    model.nameNick = [set stringForColumn:@"name_nick"];
    model.age = [set intForColumn:@"age"];
    model.gender = [set intForColumn:@"gender"];
    model.urlProfileThumbnail = [set stringForColumn:@"profile_url"];
    model.constellation = [set stringForColumn:@"constellation"];
    model.schoolID = [set longForColumn:@"school_id"];
    model.timeSendBiu = [set longForColumn:@"time_biu_send"];
    model.isShow = [set boolForColumn:@"is_show"];
    
    return model;
}

- (NSString *)tableName{
    return BIU_BIU;
}

@end
