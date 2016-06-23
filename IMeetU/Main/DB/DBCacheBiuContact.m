//
//  DBCacheBiuContact.m
//  IMeetU
//
//  Created by zhanghao on 16/3/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "DBCacheBiuContact.h"
#import "DBCache.h"
#import "FMDatabase.h"
#import "ModelContact.h"
#import "ModelContacts.h"
#import "AFNetworking.h"
#import <YYKit/YYKit.h>
#import "XMUrlHttp.h"
#import "ModelResponse.h"
#import "UserDefultDB.h"
#import "UserDefultAccount.h"

@implementation DBCacheBiuContact

+ (instancetype)shareDAO{
    static DBCacheBiuContact *dao;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dao = [[DBCacheBiuContact alloc] init];
    });
    
    return dao;
}

- (instancetype)init{
    if (self = [super init]) {
        if ([self.db open]) {
            NSString *sql = [NSString stringWithFormat:@"create table  if not exists %@(user_code TEXT, name_nick TEXT, age INTEGER, gender INTEGER, profile_url TEXT, constellation TEXT, school TEXT, is_graduate INTEGER)", self.tableName];
            [self.db executeUpdate:sql];
            [self.db close];
        }
        return self;
    }
    return nil;
}

- (void)insertWithModel:(ModelContact *)model{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@(user_code, name_nick, age, gender, profile_url, constellation, school, is_graduate)values(?,?,?,?,?,?,?,?)", self.tableName];
        [self.db executeUpdate:sql, model.userCode, model.nameNick, model.ageObj, model.genderObj, model.profileUrl, model.constellation, model.schoolId, model.isGraduatedObj];
        [self.db close];
    }
}

- (void)updateFromNetworkWithIsForced:(BOOL)forcedUpdate block:(void (^)(BOOL, ModelContacts *))block{
    
    if (forcedUpdate || [UserDefultDB finalUpdateTimeContactTimeout]) {
        AFHTTPSessionManager *httPManager = [AFHTTPSessionManager manager];
        httPManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httPManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"index":@0, @"numbers":[NSNumber numberWithInteger:NSIntegerMax]};
        [httPManager POST:[XMUrlHttp xmContactList] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ModelResponse *response = [ModelResponse responselWithObject:responseObject];
            if (response.state == 200) {
                ModelContacts *contacts = [ModelContacts modelWithDictionary:response.data];
                [self updateContactWithArr:contacts.contacts];
                if (!forcedUpdate) {
                    [UserDefultDB finalUpdateTimeContactUpdate];
                }
                
                if (block) {
                    block(YES, contacts);
                }
            }else{
                if (block) {
                    block(NO, nil);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                block(NO, nil);
            }
        }];
    }else{
        if (block) {
            block(YES, [ModelContacts modelWithContacts:[self selectAllContact]]);
        }
    }
}

- (void)updateContactWithArr:(NSArray*)contact{
    [self cleanDB];
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@(user_code, name_nick, age, gender, profile_url, constellation, school, is_graduate)values(?,?,?,?,?,?,?,?)", self.tableName];
        for (ModelContact *model in contact) {
            [self.db executeUpdate:sql, model.userCode, model.nameNick, model.ageObj, model.genderObj, model.profileUrl, model.constellation, model.schoolId, model.isGraduatedObj, nil];
        }
        [self.db close];
    }
}

- (ModelContact*)selectContactWithUserCode:(NSString*)userCode{
    ModelContact *model = nil;

    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select *from %@ where user_code=?", self.tableName];
        FMResultSet *set = [self.db executeQuery:sql, userCode, nil];
        if (set.next) {
            model = [self modelContactWithResultSet:set];
        }
        [self.db close];
    }
    return model;
}

- (NSArray*)selectAllContact{
    NSMutableArray *contacts = nil;
    if ([self.db open]) {
        contacts = [NSMutableArray array];
        NSString *sql = [NSString stringWithFormat:@"select *from %@", self.tableName];
        FMResultSet *set = [self.db executeQuery:sql, nil];
        while (set.next) {
            ModelContact *contact = [self modelContactWithResultSet:set];
            [contacts addObject:contact];
        }
        [self.db close];
    }
    return contacts;
}

- (void)cleanDB{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@", self.tableName];
        [self.db executeUpdate:sql];
        [self.db close];
    }
}

- (void)deleteContacterWithUserCode:(NSString *)userCode{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where user_code=?", self.tableName];
        [self.db executeUpdate:sql, userCode];
        [self.db close];
    }
}

- (NSString *)tableName{
    return BIU_CONTACT;
}

- (ModelContact*)modelContactWithResultSet:(FMResultSet*)set{
    ModelContact *model = [[ModelContact alloc] init];
    model.profileUrl = [set stringForColumn:@"profile_url"];
    model.userCode = [set stringForColumn:@"user_code"];
    model.nameNick = [set stringForColumn:@"name_nick"];
    model.age = [set longLongIntForColumn:@"age"];
    model.gender = [set longLongIntForColumn:@"gender"];
    model.constellation = [set stringForColumn:@"constellation"];
    model.schoolId = [set stringForColumn:@"school"];
    model.isGraduated = [set longLongIntForColumn:@"is_graduate"];
    
    return model;
}

@end
