//
//  ModelMatchSettingUpdate.m
//  IMeetU
//
//  Created by zhanghao on 16/3/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelMatchSettingUpdate.h"

@implementation ModelMatchSettingUpdate

+ (instancetype)model{
    return [[ModelMatchSettingUpdate alloc] init];
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"token":@"token",
             @"deviceUUID":@"device_code",
             @"parameters":@"parameters",
             
             @"gender":@"sex",
             @"areaRange":@"city",
             @"ageCeiling":@"age_up",
             @"ageFloor":@"age_down",
             @"characters":@"personalized_tags",
             
             @"pushNewMsg":@"message",
             @"pushSound":@"sound",
             @"pushVibration":@"vibration"
             };
}

@end
