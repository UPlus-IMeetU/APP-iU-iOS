//
//  ModelBiuMainRefreshData.m
//  IMeetU
//
//  Created by zhanghao on 16/3/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuMainRefreshData.h"

@implementation ModelBiuMainRefreshData

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"virtualCurrency":@"virtual_currency",
             @"profileState":@"iconStatus",
             @"token":@"token",
             @"faceStars":@"users",
             @"matchUser":@"mylatestbiu",
             @"isBiuEnd":@"is_biu_end"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"faceStars" : [ModelBiuFaceStar class]
             };
}

@end
