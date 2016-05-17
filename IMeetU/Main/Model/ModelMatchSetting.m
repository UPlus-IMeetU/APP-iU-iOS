//
//  ModelMatchSetting.m
//  IMeetU
//
//  Created by zhanghao on 16/3/10.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelMatchSetting.h"
#import "ModelCharacher.h"

@implementation ModelMatchSetting

+ (instancetype)model{
    return [[ModelMatchSetting alloc] init];
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
             @"pushVibration":@"vibration",
             
             @"userGender":@"sex2",
             @"userCharcterCount":@"personalityTags"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"characters":[ModelCharacher class]
             };
}

@end
