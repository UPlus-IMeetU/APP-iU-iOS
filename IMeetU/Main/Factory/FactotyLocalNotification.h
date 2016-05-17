//
//  FactotyLocalNotification.h
//  IMeetU
//
//  Created by zhanghao on 16/4/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FactoryLocalNotificationType){
    FactoryLocalNotificationTypeNone,
    FactoryLocalNotificationTypeIMReceiveMsg
};
@interface FactotyLocalNotification : NSObject

+ (UILocalNotification*)notificationIMReceiveMsgWithAlertBody:(NSString*)alertBody userCode:(NSString*)userCode;

+ (FactoryLocalNotificationType)notificationTypeWithNotification:(UILocalNotification*)notification;
@end
