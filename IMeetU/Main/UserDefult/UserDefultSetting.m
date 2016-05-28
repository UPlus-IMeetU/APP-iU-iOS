//
//  UserDefultSetting.m
//  IMeetU
//
//  Created by zhanghao on 16/4/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultSetting.h"

@implementation UserDefultSetting

+ (BOOL)msgNotification{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MsgNotification] boolValue];
}
+ (void)msgNotification:(BOOL)notifi{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:notifi] forKey:MsgNotification];
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
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MsgNotificationIsVibration] boolValue];
}
+ (void)msgNotificationVibration:(BOOL)isVibration{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isVibration] forKey:MsgNotificationIsVibration];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
