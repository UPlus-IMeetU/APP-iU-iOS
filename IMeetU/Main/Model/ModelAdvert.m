//
//  AdvertModel.m
//  IMeetU
//
//  Created by Spring on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelAdvert.h"

@implementation ModelAdvert

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"cover":@"cover",
             @"name":@"name",
             @"url":@"url"
             };
}
@end
