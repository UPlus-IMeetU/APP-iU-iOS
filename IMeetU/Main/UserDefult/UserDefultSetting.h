//
//  UserDefultSetting.h
//  IMeetU
//
//  Created by zhanghao on 16/4/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefultSetting : NSObject

+ (BOOL)msgNotification;
+ (void)msgNotification:(BOOL)notifi;

+ (BOOL)msgNotificationIsSound;
+ (void)msgNotificationIsSound:(BOOL)isSound;

+ (BOOL)msgNotificationVibration;
+ (void)msgNotificationVibration:(BOOL)isVibration;

@end
