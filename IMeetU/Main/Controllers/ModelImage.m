//
//  ModelImage.m
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelImage.h"

@implementation ModelImage
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"imageWidth":@"w",
             @"imageHeight":@"h",
             @"imageUrl":@"url"
        };
}

@end
