//
//  ModelCommunityNotifies.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCommunityNotifies.h"
#import "ModelCommunityNotice.h"

@implementation ModelCommunityNotifies

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"notifies" : [ModelCommunityNotice class]
             };
}

@end
