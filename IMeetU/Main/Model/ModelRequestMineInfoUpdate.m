//
//  ModelRequestMineInfoUpdate.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelRequestMineInfoUpdate.h"
#import "UserDefultAccount.h"

@implementation ModelRequestMineInfoUpdate

+ (instancetype)model{
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.token = [UserDefultAccount token];
    model.deviceCode = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    return model;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"deviceCode":@"device_code",
             @"token":@"token",
             @"nameNick":@"nickname",
             @"aboutMe":@"description",
             @"birthday":@"birth_date",
             @"constellation":@"starsign",
             @"city":@"city",
             @"cityNum":@"cityf",
             @"homeTown":@"hometown",
             @"bodyHeight":@"height",
             @"bodyWeight":@"weight",
             @"isGraduated":@"isgraduated",
             @"profession":@"career",
             @"school":@"school",
             @"company":@"company",
             @"characters":@"personality_tags",
             @"interests":@"interested_tags",
             @"finalActyTime":@"activity_time",
             @"ForeOrBackGround":@"app_status",
             @"parameters":@"parameters"
             };
}

@end
