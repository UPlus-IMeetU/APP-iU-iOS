//
//  XMUrlHttp.m
//  IMeetU
//
//  Created by zhanghao on 16/3/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMUrlHttp.h"

@implementation XMUrlHttp

#pragma mark - 注册相关
+ (NSString *)xmIsRegisteredPhone{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/auth/checkPhoneIsRegistered"];
}

+ (NSString *)xmRegister{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/auth/register"];
}

+ (NSString *)xmLogin{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/auth/login"];
}

+ (NSString *)xmLogout{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/auth/logout"];
}

+ (NSString *)xmResetPassword{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/auth/updatePassword"];
}

#pragma mark - 个人主页相关
+ (NSString *)xmMineInfo{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/getUserInfo"];
}

+ (NSString *)xmUpdateProfile{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/updateIcon"];
}

+ (NSString *)xmUpdateMineInfo{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/updateUserInfo"];
}

+ (NSString *)xmPhotoAdd{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/savePhoto"];
}

+ (NSString *)xmPhotoDelete{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/delPhoto"];
}
#pragma mark - OSS令牌
+ (NSString *)xmOSSToken{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/getOSSSecurityToken"];
}

#pragma mark - 个性、兴趣、发biu话题
+ (NSString *)xmAllCharactersInterestChat{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/getTags"];
}

+ (NSString *)xmAllCharactersInterestChatTopic{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/getTags"];
}

#pragma mark - biubiu相关
#pragma mark 发biubiu
+ (NSString *)xmBiuSend{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biu/sendBiu"];
}
#pragma mark 更新biubiu主页信息（已登录）
+ (NSString *)xmUpdateBiuMainInfo{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/biubiuList"];
}

+ (NSString *)xmReceiveBiuDetails{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biu/getBiuDetails"];
}

+ (NSString *)xmReceiveBiuGrabBiu{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biu/grabBiu"];
}

+ (NSString *)xmReceiveBiuUnreceiveTA{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/nolongerMatch"];
}

+ (NSString *)xmUpdateBiuMainInfoUnlogin{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/auth/biubiuListUnlogin"];
}

+ (NSString *)xmUpdateBiuMatchUserStatus{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/updateChatListState"];
}

#pragma mark - 更新推送channel
+ (NSString *)xmUpdateChannel{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/updateChannelIdAndDeviceType"];
}

#pragma mark - 更新位置
+ (NSString *)xmUpdateLocation{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/updateLocation"];
}

#pragma mark - 匹配设置
+ (NSString *)xmMatchSetting{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/getSettings"];
}
+ (NSString*)xmMatchSettingUpdate{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/info/updateSettings"];
}

#pragma mark - 创建biu币订单
+ (NSString *)xmPayCreateBiuOrder{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/createBill"];
}

+ (NSString *)xmPayVerifyUmiOrderRes{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/checkBill"];
}

+ (NSString *)xmContactList{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/getFriendsList"];
}

+ (NSString *)xmUnfriendYou{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/removeFriend"];
}

+ (NSString *)xmReportUser{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/report"];
}

+ (NSString *)xmChangeUserStateRead{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/updateIconStatus"];
}

+ (NSString *)xmEnablePay{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/enablePay"];
}

+ (NSString*)xmUpdateBill{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/app/biubiu/updateBill"];
}

+ (NSString *)xmGetActivity{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/activity/getActivity"];
}

+ (NSString *)xmGetActivityContents{
    return [XMUrlHttp connectWithOperation:@"/meetu_maven/activity/getContents"];
}

+ (NSString *)xmLoadMatchUsers{
    return [XMUrlHttp testConnectWithOperation:@"/meetu_maven/app/biu/getTargetBiuList"];
}

+ (NSString *)testConnectWithOperation:(NSString *)operation{
    NSString *host = @"http://123.57.26.168:8080";
    return [NSString stringWithFormat:@"%@%@", host, operation];
}

+ (NSString *)xmGetUMi{
    return [XMUrlHttp testConnectWithOperation:@"/meetu_maven/app/biu/getVC"];
}

+ (NSString *)connectWithOperation:(NSString *)operation{
    //NSString *host = @"http://app.iu.imeetu.cc";
    NSString *host = @"http://123.57.26.168:8080";
    return [NSString stringWithFormat:@"%@%@", host, operation];
}
@end
