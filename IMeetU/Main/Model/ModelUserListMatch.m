//
//  ModelUserListMatch.m
//  IMeetU
//
//  Created by zhanghao on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelUserListMatch.h"
#import "ModelUserMatch.h"

@implementation ModelUserListMatch

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"showIntervalMax":@"biu_time_interval",
             @"showIntervalMin":@"biu_time_interval_min",
             @"hasNext":@"has_next",
             @"token":@"token",
             @"users":@"users"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"users" : [ModelUserMatch class]
             };
}

@end
