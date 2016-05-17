//
//  ModelCharacher.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCharacher.h"

@implementation ModelCharacher


+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"code":@"code",
             @"content":@"name"
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"code", @"content"];
}

@end
