//
//  UserDefultAccount.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultAccount.h"

#define TOKEN @"tokenLogin"
#define IM_NAME @"imName"
#define IM_PASSWD @"imPassword"
#define USER_NAME @"userName"
#define USER_CODE @"userCode"
#define USER_PROFILE_STATUS @"userProfileStatus"
#define USER_PROFILE_URL_THUMBNAIL @"userProfileUrlThumbnail"
#define DIALOYURL @"dialogURL"
#define UPDATEAT @"updateAt"
#define HAVETOVIEW @"haveToView"
#define TOPIC @"topic"
#define GENDER @"gender"
#define XG_DEVICE_TOKEN @"XGDeviceToken"

@implementation UserDefultAccount

+ (NSString *)token{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    return token?token:@"";
}
+ (void)setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)updateToken:(NSString*)token{
    if (token && token.length>30) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)isLogin{
    NSString *token = [self token];
    NSString *userCode = [self userCode];
    NSString *userName = [self userName];
    
    return token.length>0 && userCode.length>0 && userName.length>0;
}

+ (NSString *)imName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:IM_NAME];
}
+ (void)setImName:(NSString *)imName{
    [[NSUserDefaults standardUserDefaults] setObject:imName forKey:IM_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)imPasswork{
    return [[NSUserDefaults standardUserDefaults] objectForKey:IM_PASSWD];
}
+ (void)setImPasswork:(NSString *)imPasswork{
    [[NSUserDefaults standardUserDefaults] setValue:imPasswork forKey:IM_PASSWD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userName{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    return userName?userName:@"";
}
+ (void)setUserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)updateUserName:(NSString *)userName{
    if (userName && userName.length>0) {
        [UserDefultAccount setUserName:userName];
    }
}

+ (NSString *)userCode{
    NSString *userCode = [[NSUserDefaults standardUserDefaults] objectForKey:USER_CODE];
    return userCode?userCode:@"";
}
+ (void)setUserCode:(NSString *)userCode{
    [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:USER_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userProfileUrlThumbnail{
    NSString *userProfileUrlThumbnail = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE_URL_THUMBNAIL];
    return userProfileUrlThumbnail?userProfileUrlThumbnail:@"";
}
+ (void)setUserProfileUrlThumbnail:(NSString *)userProfileUrlThumbnail{
    [[NSUserDefaults standardUserDefaults] setObject:userProfileUrlThumbnail forKey:USER_PROFILE_URL_THUMBNAIL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)userProfileStatus{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE_STATUS] intValue];
}
+ (void)setUserProfileStatus:(int)status{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:status] forKey:USER_PROFILE_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)xgDeviceToken{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:XG_DEVICE_TOKEN];
    return deviceToken?deviceToken:@"";
}
+ (BOOL)xgHaveDeviceToken{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:XG_DEVICE_TOKEN];
    return deviceToken&&deviceToken.length>0;
}
+ (void)xgSetDeviceToken:(NSString *)deviceToken{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:XG_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(NSString *)dialoyURL{
    NSString *dialoyURL = [[NSUserDefaults standardUserDefaults] objectForKey:DIALOYURL];
    return dialoyURL ? dialoyURL : @"";
}
+(void)setDialoyURL:(NSString *)dialoyURL{
    [[NSUserDefaults standardUserDefaults] setObject:dialoyURL forKey:DIALOYURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSUInteger)updateAt{
    NSUInteger updateAt = [[[NSUserDefaults standardUserDefaults] objectForKey:UPDATEAT] integerValue];
    return updateAt;
}
+(void)setUpdateAt:(NSUInteger)updateAt{
    [[NSUserDefaults standardUserDefaults] setObject:@(updateAt) forKey:UPDATEAT];
}

+(NSInteger)haveToView{
    NSUInteger haveToView = [[[NSUserDefaults standardUserDefaults] objectForKey:HAVETOVIEW] integerValue];
    return haveToView;
}
+(void)setHaveToView:(NSInteger)haveToView{
     [[NSUserDefaults standardUserDefaults] setObject:@(haveToView) forKey:HAVETOVIEW];
}


+ (NSString *)topic{
    return [[NSUserDefaults standardUserDefaults] objectForKey:TOPIC];
}
+ (void)setTopic:(NSString *)topic{
    [[NSUserDefaults standardUserDefaults] setObject:topic forKey:TOPIC];
}

+ (NSString *)gender{
    return [[NSUserDefaults standardUserDefaults] objectForKey:GENDER];
}
+ (void)setGender:(NSString *)gender{
    [[NSUserDefaults standardUserDefaults] setObject:gender forKey:GENDER];
}

+ (void)cleanAccountCache{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOPIC];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IM_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IM_PASSWD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_CODE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_PROFILE_URL_THUMBNAIL];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DIALOYURL];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UPDATEAT];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HAVETOVIEW];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GENDER];
    
}

@end
