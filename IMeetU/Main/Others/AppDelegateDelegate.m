//
//  AppDelegateDelegate.m
//  IMeetU
//
//  Created by zhanghao on 16/3/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "AppDelegateDelegate.h"
#import <YYKit/YYKit.h>

#import "ModelRemoteNotification.h"

#import "EMSDK.h"
#import "XMUrlHttp.h"
#import "AFNetworking.h"
#import "UserDefultAccount.h"
#import "FactotyLocalNotification.h"
#import "DBCacheBiuContact.h"
#import "ModelContact.h"
#import "UserDefultMsg.h"
#import "UserDefultSetting.h"
#import "ControllerTabBarMain.h"

@interface AppDelegateDelegate()

@end
@implementation AppDelegateDelegate

+ (instancetype)shareAppDelegateDelegate{
    static AppDelegateDelegate *obj;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        obj = [[AppDelegateDelegate alloc] init];
    });
    
    return obj;
}

- (void)appDelegate:(AppDelegate *)appDelegate isEnterFromRemoteNotification:(BOOL)isEnterFromRemoteNotification remoteNotificationUserInfo:(ModelRemoteNotification*)userInfo{
    if (self.delegateAppDelegate) {
        if ([self.delegateAppDelegate respondsToSelector:@selector(appDelegate:isEnterFromRemoteNotification:remoteNotificationUserInfo:)]) {
            [self.delegateAppDelegate appDelegate:appDelegate isEnterFromRemoteNotification:isEnterFromRemoteNotification remoteNotificationUserInfo:userInfo];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    if (self.delegateAppDelegate) {
        if ([self.delegateAppDelegate respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [self.delegateAppDelegate applicationWillEnterForeground:application];
        }
    }
}

- (void)didRemovedFromServer{
    [UserDefultAccount cleanAccountCache];
    
//    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
//    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"user_code":[UserDefultAccount userCode], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
//    [httpManager POST:[XMUrlHttp xmLogout] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
}

- (void)didReceiveMessages:(NSArray *)aMessages{
    //未读消息数加一
    [UserDefultMsg unreadMsgCountIncrease];
    [ControllerTabBarMain setBadgeMsgWithCount:[UserDefultMsg unreadMsgCount]];
    
    
    
    for (EMMessage *message in aMessages) {
        
        NSString *senderName = message.ext[@"MsgSenderName"];
        NSString *senderCode = message.from;
        if (senderName) {
            senderName = [NSString stringWithFormat:@"%@:", senderName];
        }else{
            senderName = @"";
            ModelContact *model = [[DBCacheBiuContact shareDAO] selectContactWithUserCode:message.from];
            if (model && model.nameNick) {
                senderName = [NSString stringWithFormat:@"%@:", model.nameNick];
            }
            
        }
        EMMessageBody *msgBody = message.body;
        
        NSString *localNotificationAlertBody = @"";
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                localNotificationAlertBody = textBody.text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                localNotificationAlertBody = @"[发来一张图片]";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                localNotificationAlertBody = @"[发来一个位置]";
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                localNotificationAlertBody = @"[发来一段语音]";
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                localNotificationAlertBody = @"[发来一段视频]";
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                localNotificationAlertBody = @"[发来一个文件]";
            }
                break;
                
            default:
                break;
        }
        if ([UserDefultSetting msgNotification]) {
            [FactotyLocalNotification notificationIMReceiveMsgWithAlertBody:[NSString stringWithFormat:@"%@%@", senderName, localNotificationAlertBody] userCode:senderCode];
        }
        
    }
}

@end
