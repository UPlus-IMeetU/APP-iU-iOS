//
//  ModelCommunityNotice.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCommunityNotice.h"

@implementation ModelCommunityNotice

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"type":@"type",
             @"isRead":@"isRead",
             @"userCode":@"userCode",
             @"userName":@"userName",
             @"userProfile":@"userHead",
             @"userSchool":@"userSchool",
             @"createAt":@"createAt",
             @"desc":@"desc",
             @"postId":@"postId",
             @"postImg":@"postImg",
             @"postContent":@"postContent",
             };
}

@end
