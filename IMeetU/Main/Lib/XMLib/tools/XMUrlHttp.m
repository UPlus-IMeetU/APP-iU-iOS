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
    return [XMUrlHttp connectWithOperation:@"/app/auth/checkPhoneIsRegistered"];
}

+ (NSString *)xmRegister{
    return [XMUrlHttp connectWithOperation:@"/app/auth/register"];
}

+ (NSString *)xmLogin{
    return [XMUrlHttp connectWithOperation:@"/app/auth/login"];
}

+ (NSString *)xmLogout{
    return [XMUrlHttp connectWithOperation:@"/app/auth/logout"];
}

+ (NSString *)xmResetPassword{
    return [XMUrlHttp connectWithOperation:@"/app/auth/updatePassword"];
}

#pragma mark - 个人主页相关
+ (NSString *)xmMineInfo{
    return [XMUrlHttp connectWithOperation:@"/app/info/getUserInfo"];
}

+ (NSString *)xmUpdateProfile{
    return [XMUrlHttp connectWithOperation:@"/app/info/updateIcon"];
}

+ (NSString *)xmUpdateMineInfo{
    return [XMUrlHttp connectWithOperation:@"/app/info/updateUserInfo"];
}

+ (NSString *)xmPhotoAdd{
    return [XMUrlHttp connectWithOperation:@"/app/info/savePhoto"];
}

+ (NSString *)xmPhotoDelete{
    return [XMUrlHttp connectWithOperation:@"/app/info/delPhoto"];
}
#pragma mark - OSS令牌
+ (NSString *)xmOSSToken{
    return [XMUrlHttp connectWithOperation:@"/app/info/getOSSSecurityToken"];
}

#pragma mark - 个性、兴趣、发biu话题
+ (NSString *)xmAllCharactersInterestChat{
    return [XMUrlHttp connectWithOperation:@"/app/info/getTags"];
}

+ (NSString *)xmAllCharactersInterestChatTopic{
    return [XMUrlHttp connectWithOperation:@"/app/info/getTags"];
}

#pragma mark - biubiu相关
#pragma mark 发biubiu
+ (NSString *)xmBiuSend{
    return [XMUrlHttp connectWithOperation:@"/app/biu/sendBiu"];
}
#pragma mark 更新biubiu主页信息（已登录）
+ (NSString *)xmUpdateBiuMainInfo{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/biubiuList"];
}

+ (NSString *)xmReceiveBiuDetails{
    return [XMUrlHttp connectWithOperation:@"/app/biu/getBiuDetails"];
}

+ (NSString *)xmReceiveBiuGrabBiu{
    return [XMUrlHttp connectWithOperation:@"/app/biu/grabBiu"];
}

+ (NSString *)xmReceiveBiuUnreceiveTA{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/nolongerMatch"];
}

+ (NSString *)xmUpdateBiuMainInfoUnlogin{
    return [XMUrlHttp connectWithOperation:@"/app/auth/biubiuListUnlogin"];
}

+ (NSString *)xmUpdateBiuMatchUserStatus{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/updateChatListState"];
}

#pragma mark - 更新推送channel
+ (NSString *)xmUpdateChannel{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/updateChannelIdAndDeviceType"];
}

#pragma mark - 更新位置
+ (NSString *)xmUpdateLocation{
    return [XMUrlHttp connectWithOperation:@"/app/info/updateLocation"];
}

#pragma mark - 匹配设置
+ (NSString *)xmMatchSetting{
    return [XMUrlHttp connectWithOperation:@"/app/info/getSettings"];
}
+ (NSString*)xmMatchSettingUpdate{
    return [XMUrlHttp connectWithOperation:@"/app/info/updateSettings"];
}

#pragma mark - 创建biu币订单
+ (NSString *)xmPayCreateBiuOrder{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/createBill"];
}

+ (NSString *)xmPayVerifyUmiOrderRes{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/checkBill"];
}

+ (NSString *)xmContactList{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/getFriendsList"];
}

+ (NSString *)xmUnfriendYou{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/removeFriend"];
}

+ (NSString *)xmReportUser{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/report"];
}

+ (NSString *)xmChangeUserStateRead{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/updateIconStatus"];
}

+ (NSString *)xmEnablePay{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/enablePay"];
}

+ (NSString*)xmUpdateBill{
    return [XMUrlHttp connectWithOperation:@"/app/biubiu/updateBill"];
}

+ (NSString *)xmGetActivity{
    return [XMUrlHttp connectWithOperation:@"/activity/getActivity"];
}

+ (NSString *)xmGetActivityContents{
    return [XMUrlHttp connectWithOperation:@"/activity/getContents"];
}

+ (NSString *)xmLoadMatchUsers{
    return [XMUrlHttp connectWithOperation:@"/app/biu/getTargetBiuList"];
}

+ (NSString *)xmLoadGrabBiuList{
    return [XMUrlHttp connectWithOperation:@"/app/biu/getGrabBiuList"];
}

+ (NSString *)xmAcceptUserGrabBiu{
    return [XMUrlHttp connectWithOperation:@"/app/biu/acceptBiu"];
}

+ (NSString *)xmShutdownBiu{
    return [XMUrlHttp connectWithOperation:@"/app/biu/endBiu"];
}

+ (NSString *)xmGetUMi{
    return [XMUrlHttp connectWithOperation:@"/app/biu/getVC"];
}

+ (NSString *)connectWithOperation:(NSString *)operation{
    NSString *host = @"http://app.iu.imeetu.cc/meetu_maven_new/";
    return [NSString stringWithFormat:@"%@%@", host, operation];
}
@end
