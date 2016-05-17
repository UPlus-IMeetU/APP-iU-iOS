
//
//  ModelMinePhoto.m
//  IMeetU
//
//  Created by zhanghao on 16/3/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelMinePhoto.h"

@implementation ModelMinePhoto

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"photoName":@"photoName",
             @"photoCode":@"photoCode",
             @"photoUrlOrigin":@"photoOrigin",
             @"photoUrlThumbnail":@"photoThumbnail"
             };
}

@end
