//
//  ModelBiuAccepts.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuAccepts.h"
#import "ModelBiuAccept.h"

@implementation ModelBiuAccepts

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"token" : @"token",
             @"message" : @"message",
             @"users" : @"users"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"users":[ModelBiuAccept class]
             };
}

@end
