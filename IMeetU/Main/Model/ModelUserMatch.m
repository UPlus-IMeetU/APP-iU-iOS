//
//  ModelUserMatch.m
//  IMeetU
//
//  Created by zhanghao on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelUserMatch.h"

@implementation ModelUserMatch

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userCode":@"user_code",
             @"nameNick":@"nickname",
             @"urlProfileThumbnail":@"icon_thumbnailUrl",
             @"age":@"age",
             @"gender":@"sex",
             @"constellation":@"starsign",
             @"schoolID":@"school",
             @"matchScore":@"matching_score",
             @"distanceToMe":@"distance",
             @"timeSendBiu":@"time",
             @"topic":@"chat_tags"
             };
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"isShow"];
}

@end
