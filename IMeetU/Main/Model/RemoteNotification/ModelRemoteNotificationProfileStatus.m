//
//  ModelRemoteNotificationProfileStatus.m
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelRemoteNotificationProfileStatus.h"

@implementation ModelRemoteNotificationProfileStatus

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"profileStatus":@"iconStatus",
             @"time":@"time"
             };
}

@end
