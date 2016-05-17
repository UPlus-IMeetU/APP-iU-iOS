//
//  DBCity.m
//  MeetU
//
//  Created by zhanghao on 15/8/10.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "DBCity.h"
#import "FMDatabase.h"
#import "NSDate+plug.h"

@implementation DBCity

+(FMDatabase*)getDB{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"sqlite"];
    return [FMDatabase databaseWithPath:path];
}

+(NSArray*)selectProvince{
    NSMutableArray *provinces = [NSMutableArray array];
    FMDatabase *db = [DBCity getDB];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"select province, province_num from citys group by province order by province_num asc"];
        while (set.next) {
            NSMutableDictionary *province = [NSMutableDictionary dictionary];
            [province setValue:[set stringForColumn:@"province"] forKey:@"name"];
            [province setValue:[NSNumber numberWithLong:[set longForColumn:@"province_num"]] forKey:@"num"];
            [provinces addObject:province];
        }
    }
    return provinces;
}

+(NSArray*)selectCityWithProvince:(NSString*)province{
    NSMutableArray *citys = [NSMutableArray array];
    FMDatabase *db = [DBCity getDB];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"select city, city_num from citys where province = ? group by city order by city_num asc", province];
        while (set.next) {
            NSMutableDictionary *city = [NSMutableDictionary dictionary];
            [city setValue:[set stringForColumn:@"city"] forKey:@"name"];
            [city setValue:[NSNumber numberWithLong:[set longForColumn:@"city_num"]] forKey:@"num"];
            [citys addObject:city];
        }
    }
    return citys;
}

+(NSString*)addressIdWithProvince:(NSString*)province city:(NSString*)city{
    
    FMDatabase *db = [DBCity getDB];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"select id from citys where province = ? and city = ?", province, city];
        if (set.next) {
            return [set stringForColumn:@"id"];
        }
    }
    return @"";
}

+ (NSString*)addressWithId:(NSString *)Id{
    
    FMDatabase *db = [DBCity getDB];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"select province, city from citys where id = ?", Id];
        if (set.next) {
            return [NSString stringWithFormat:@"%@ %@", [set stringForColumn:@"province"], [set stringForColumn:@"city"]];;
        }
    }
    
    return @"";
}

+ (NSDictionary*)addressDicWithId:(NSString *)Id{
    
    FMDatabase *db = [DBCity getDB];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"select province, city from citys where id = ?", Id];
        if (set.next) {
            return @{
                     @"province":[set stringForColumn:@"province"],
                     @"city":[set stringForColumn:@"city"]};
        }
    }
    
    return @{};
}

+ (NSInteger)selectIndexOfProvince:(NSString*)province{
    NSMutableArray *provinces = [NSMutableArray array];
    FMDatabase *db = [DBCity getDB];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"select province from citys group by province order by province_num asc"];
        while (set.next) {
            [provinces addObject:[set stringForColumn:@"province"]];
        }
        return [provinces indexOfObject:province];
    }
    
    return NSNotFound;
}

+ (NSInteger)selectIndexOfCity:(NSString*)city province:(NSString*)province{
    NSMutableArray *citys = [NSMutableArray array];
    FMDatabase *db = [DBCity getDB];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"select city from citys where province = ? group by city order by city_num asc", province];
        while (set.next) {
            [citys addObject:[set stringForColumn:@"city"]];
        }
        return [citys indexOfObject:city];
    }
    return NSNotFound;
}

@end
