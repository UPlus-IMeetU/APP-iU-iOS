//
//  ModelRemoteNotificationSendBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelRemoteNotificationSendBiu.h"

@implementation ModelRemoteNotificationSendBiu

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
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
