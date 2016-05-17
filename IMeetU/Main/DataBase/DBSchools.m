//
//  DBSchools.m
//  MeetU
//
//  Created by zhanghao on 15/11/1.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "DBSchools.h"
#import "FMDatabase.h"

@interface DBSchools()
@property (nonatomic, strong) FMDatabase *db;
@end
@implementation DBSchools

+ (instancetype)shareInstance{
    static DBSchools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DBSchools alloc] init];
    });
    return instance;
}

- (FMDatabase *)db{
    if (!_db) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"schools" ofType:@"sqlite"];
        _db = [FMDatabase databaseWithPath:path];
    }
    return _db;
}

- (NSArray *)selectAllSchool{
    NSMutableArray *schools;
    if ([self.db open]) {
        schools = [NSMutableArray array];
        FMResultSet *set = [self.db executeQuery:@"select *from schools order by school_id"];
        while (set.next) {
            NSMutableDictionary *school = [NSMutableDictionary dictionary];
            [school setObject:[NSNumber numberWithLong:[set longForColumn:@"province_id"]] forKey:@"provinceId"];
            [school setObject:[NSNumber numberWithLong:[set longForColumn:@"school_id"]] forKey:@"schoolId"];
            [school setObject:[set stringForColumn:@"school_name"] forKey:@"schoolName"];
            [schools addObject:school];
        }
    }
    return schools;
}

- (NSArray *)selectSchoolWithKey:(NSString *)key{
    NSMutableArray *schools;
    if ([self.db open]) {
        schools = [NSMutableArray array];
        NSMutableString *likeKey = [NSMutableString stringWithString:@"%%"];
        for (int i=0; i<key.length; i++) {
            [likeKey appendString:[key substringWithRange:NSMakeRange(i, 1)]];
            [likeKey appendString:@"%%"];
        }
        FMResultSet *set = [self.db executeQuery:@"select *from schools where school_name like ? order by school_id", likeKey];
        while (set.next) {
            NSMutableDictionary *school = [NSMutableDictionary dictionary];
            [school setObject:[NSNumber numberWithLong:[set longForColumn:@"province_id"]] forKey:@"provinceId"];
            [school setObject:[NSNumber numberWithLong:[set longForColumn:@"school_id"]] forKey:@"schoolId"];
            [school setObject:[set stringForColumn:@"school_name"] forKey:@"schoolName"];
            [schools addObject:school];
        }
    }
    return schools;
}

- (NSString *)schoolNameWithID:(NSInteger)schoolId{
    NSDictionary *school = [self schoolWithID:schoolId];
    
    return school[@"schoolName"];
}

- (NSDictionary *)schoolWithID:(NSInteger)schoolId{
    NSMutableDictionary *school;
    if ([self.db open]) {
        FMResultSet *set = [self.db executeQuery:@"select *from schools where school_id=?", [NSNumber numberWithInteger:schoolId]];
        if (set.next) {
            school = [NSMutableDictionary dictionary];
            [school setObject:[NSNumber numberWithLong:[set longForColumn:@"province_id"]] forKey:@"provinceId"];
            [school setObject:[NSNumber numberWithLong:[set longForColumn:@"school_id"]] forKey:@"schoolId"];
            [school setObject:[set stringForColumn:@"school_name"] forKey:@"schoolName"];
        }
    }
    return school;
}

- (NSArray *)departmentsWithSchoolId:(NSInteger)schoolId{
    NSMutableArray *departments;
    if ([self.db open]) {
        departments = [NSMutableArray array];
        FMResultSet *set = [self.db executeQuery:@"select *from department where school_id=?", [NSNumber numberWithInteger:schoolId]];
        while (set.next) {
            NSMutableDictionary *department = [NSMutableDictionary dictionary];
            [department setObject:[NSNumber numberWithInteger:[set longLongIntForColumn:@"department_id"]] forKey:@"departmentId"];
            [department setObject:[set stringForColumn:@"department_name"] forKey:@"departmentName"];
            [departments addObject:department];
        }
        [self.db close];
    }
    return departments;
}

@end
