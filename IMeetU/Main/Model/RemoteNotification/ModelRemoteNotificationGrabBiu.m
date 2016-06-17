//
//  ModelRemoteNotificationGrabBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelRemoteNotificationGrabBiu.h"

@implementation ModelRemoteNotificationGrabBiu

+ (NSDictionary *)modelCustomPropertyMapper{

    return @{
                @"age":@"age",
                @"virtualBiuBi":@"biu_vc",
                @"profileUrl":@"icon_thumbnailUrl",
                @"nameNick":@"nickname",
                @"school":@"school",
                @"gender":@"sex",
                @"constellation":@"starsign",
                @"status":@"status",
                @"time":@"time",
                @"userCode":@"user_code"
             };
}

@end
