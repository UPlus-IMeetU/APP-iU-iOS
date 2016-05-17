//
//  UserDefultSetting.m
//  IMeetU
//
//  Created by zhanghao on 16/4/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultSetting.h"

#define MsgNotification @"UserDefultConfigMsgNotification"
#define MsgNotificationIsSound @"UserDefultConfigMsgNotificationIsSound"
#define MsgNotificationIsVibration @"UserDefultConfigMsgNotificationIsVibration"

@implementation UserDefultSetting

+ (BOOL)msgNotification{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MsgNotificationIsSound] boolValue];
}
+ (void)msgNotification:(BOOL)notifi{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:notifi] forKey:MsgNotificationIsSound];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)msgNotificationIsSound{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MsgNotificationIsSound] boolValue];
}
+ (void)msgNotificationIsSound:(BOOL)isSound{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isSound] forKey:MsgNotificationIsSound];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)msgNotificationVibration{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MsgNotificationIsSound] boolValue];
}
+ (void)msgNotificationVibration:(BOOL)isVibration{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isVibration] forKey:MsgNotificationIsSound];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
