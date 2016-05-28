//
//  FactotyLocalNotification.m
//  IMeetU
//
//  Created by zhanghao on 16/4/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "FactotyLocalNotification.h"
#import "UserDefultSetting.h"
#import <AudioToolbox/AudioToolbox.h>

#define NotificationTypeStr @"NotificationType"

@implementation FactotyLocalNotification

+ (UILocalNotification *)notificationIMReceiveMsgWithAlertBody:(NSString *)alertBody userCode:(NSString *)userCode{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = 0;
    
    if ([UserDefultSetting msgNotificationIsSound]) {
        localNotification.soundName = @"msg.wav";
    }else{
        localNotification.soundName = @"";
    }
    
    localNotification.alertBody = alertBody;
    
    localNotification.userInfo =
        @{
            NotificationTypeStr:[NSNumber numberWithInt:FactoryLocalNotificationTypeIMReceiveMsg],
            @"userCode":userCode
                                   };
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        if ([UserDefultSetting msgNotificationVibration]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    
    return localNotification;
}

+ (FactoryLocalNotificationType)notificationTypeWithNotification:(UILocalNotification *)notification{
    return [notification.userInfo[NotificationTypeStr] integerValue];
}
@end
