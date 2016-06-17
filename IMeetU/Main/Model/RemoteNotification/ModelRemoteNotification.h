//
//  ModelRemoteNotification.h
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelRemoteNotificationXG.h"
#import "ModelRemoteNotificationAPNS.h"

#import "ModelRemoteNotificationGrabBiu.h"
#import "ModelRemoteNotificationSendBiu.h"
#import "ModelRemoteNotificationProfileStatus.h"

/**
 * type类型
 ****************************100~199
 * -101 发biubiu推送
 * -102 抢biubiu推送
 ****************************200~299
 * -201 头像更新推送
 */

@interface ModelRemoteNotification : NSObject

@property (nonatomic, strong) ModelRemoteNotificationXG *xg;
@property (nonatomic, strong) ModelRemoteNotificationAPNS *apns;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL shake;
@property (nonatomic, assign) long long timestamp;

@property (nonatomic, strong) ModelRemoteNotificationGrabBiu *biuGrab;
@property (nonatomic, strong) ModelRemoteNotificationSendBiu *biuSend;
@property (nonatomic, strong) ModelRemoteNotificationProfileStatus *profileStatusChange;

@end
