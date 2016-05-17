//
//  AppDelegateDelegate.h
//  IMeetU
//
//  Created by zhanghao on 16/3/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "EMSDK.h"

@protocol AppDelegateRemoteNotificationDelegate;

@interface AppDelegateDelegate : NSObject<EMClientDelegate, EMChatManagerDelegate>

+ (instancetype)shareAppDelegateDelegate;

@property (nonatomic, weak) id<AppDelegateRemoteNotificationDelegate> delegateAppDelegate;

- (void)appDelegate:(AppDelegate*)appDelegate isEnterFromRemoteNotification:(BOOL)isEnterFromRemoteNotification remoteNotificationUserInfo:(ModelRemoteNotification*)userInfo;

- (void)applicationWillEnterForeground:(UIApplication *)application;
@end
@protocol AppDelegateRemoteNotificationDelegate <NSObject>
@optional

- (void)appDelegate:(AppDelegate*)appDelegate isEnterFromRemoteNotification:(BOOL)isEnterFromRemoteNotification remoteNotificationUserInfo:(ModelRemoteNotification*)userInfo;

- (void)applicationWillEnterForeground:(UIApplication *)application;
@end