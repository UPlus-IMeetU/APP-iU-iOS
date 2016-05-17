//
//  ModelRemoteNotification.m
//  IMeetU
//
//  Created by zhanghao on 16/3/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelRemoteNotification.h"

@implementation ModelRemoteNotification

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"typeNotifi":@"messageType",
             
             @"biuCode":@"chat_id",
             @"referenceId":@"reference_id",
             
             @"biuUserCode":@"user_code",
             @"biuUserName":@"nickname",
             @"biuUserGender":@"sex",
             @"biuUserAge":@"age",
             @"biuUserConstellation":@"starsign",
             @"biuIsGraduated":@"isgraduated",
             @"biuUserSchool":@"school",
             @"biuUserProfession":@"career",
             @"biuUserProfile":@"icon_thumbnailUrl",
             @"biuMatchTime":@"time"
             };
}

@end
