//
//  AppDelegate.h
//  IMeetU
//
//  Created by zhanghao on 16/2/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelRemoteNotification.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ModelRemoteNotification *remoteNotificationUserInfo;

+ (instancetype)shareAppDelegate;

+ (void)launchFirst;

+ (void)registerDeviceToken;

@end