//
//  ModelBiuMe.m
//  IMeetU
//
//  Created by zhanghao on 16/6/3.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuMe.h"

@implementation ModelBiuMe

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userCode":@"userCode",
             @"userName":@"userName",
             @"userProfile":@"userHead",
             @"schoolCode":@"userSchool",
             @"constellation":@"starsign",
             @"createdAt":@"createAt",
             @"gender":@"sex",
             @"age":@"age",
             @"isAccept":@"isAccept"
             };
}

@end
