//
//  ModelBiuAccept.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuAccept.h"

@implementation ModelBiuAccept

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userCode":@"user_code",
             @"nameNick":@"nickname",
             @"urlProfile":@"icon_thumbnailUrl",
             @"age":@"age",
             @"gender":@"sex",
             @"constellation":@"starsign",
             @"schoolID":@"school",
             @"status":@"status",
             @"virtualCurrency":@"biu_vc",
             @"timestamp":@"time"
             };
}

@end
