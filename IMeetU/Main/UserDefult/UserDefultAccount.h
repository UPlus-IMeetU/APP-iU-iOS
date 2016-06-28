//
//  UserDefultAccount.h
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefultAccount : NSObject

+ (NSString *)token;
+ (void)setToken:(NSString*)token;
+ (void)updateToken:(NSString*)token;
+ (BOOL)isLogin;

+ (NSString *)imName;
+ (void)setImName:(NSString *)imName;

+ (NSString *)imPasswork;
+ (void)setImPasswork:(NSString *)imPasswork;

+ (NSString *)userName;
+ (void)setUserName:(NSString *)userName;
+ (void)updateUserName:(NSString *)userName;

+ (NSString *)userCode;
+ (void)setUserCode:(NSString *)userCode;

+ (NSString *)userProfileUrlThumbnail;
+ (void)setUserProfileUrlThumbnail:(NSString *)userProfileUrlThumbnail;

+ (int)userProfileStatus;
+ (void)setUserProfileStatus:(int)status;
/**
 * 信鸽设备Token
 */
+ (NSString*)xgDeviceToken;
+ (BOOL)xgHaveDeviceToken;
+ (void)xgSetDeviceToken:(NSString*)deviceToken;

/**
 *  活动的信息
 */
+ (NSString *)dialoyURL;
+ (void)setDialoyURL:(NSString *)dialoyURL;

+ (NSUInteger)updateAt;
+ (void)setUpdateAt:(NSUInteger)updateAt;

+ (NSInteger)haveToView;
+ (void)setHaveToView:(NSInteger)haveToView;


+ (NSString *)topic;
+ (void)setTopic:(NSString *)topic;

+ (NSString *)gender;
+ (void)setGender:(NSString *)gender;

/**
 * 销毁信息
 */
+ (void)cleanAccountCache;

@end
