//
//  ModelResponseOSSSecurityToke.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelResponseOSSSecurityToke.h"

@implementation ModelResponseOSSSecurityToke

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"accessKeyId":@"accessKeyId",
             @"secretKeyId":@"accessKeySecret",
             @"securityToken":@"securityToken",
             @"expiration":@"expiration"
             };
}

@end
