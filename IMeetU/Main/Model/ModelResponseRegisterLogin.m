//
//  ModelResponseRegisterLogin.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelResponseRegisterLogin.h"

@implementation ModelResponseRegisterLogin

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"token":@"token",
             @"imName":@"username",
             @"imPasswork":@"password",
             @"userName":@"nickname",
             @"userCode":@"code",
             @"userProfileUrl":@"icon_url",
             };
}

@end
