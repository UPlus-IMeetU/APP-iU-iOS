//
//  ModelRemoteNotification.m
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelRemoteNotification.h"

@implementation ModelRemoteNotification

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"xg":@"xg",
             @"apns":@"aps",
             
             @"type":@"messageType",
             @"shake":@"vibration",
             @"timestamp":@"ptime",
             
             @"biuGrab":@"grabBiu",
             @"biuSend":@"sendBiu",
             @"profileStatusChange":@"iconState",
             };
}

@end
