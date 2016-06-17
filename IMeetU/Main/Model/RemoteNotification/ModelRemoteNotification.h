//
//  ModelRemoteNotification.h
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL shake;

@property (nonatomic, assign) NSString *biuGrab;
@property (nonatomic, assign) NSString *biuSend;
@property (nonatomic, assign) NSString *profileStatusChange;

@property (nonatomic, assign) ModelRemoteNotificationGrabBiu *objBiuGrab;
@property (nonatomic, assign) ModelRemoteNotificationSendBiu *objBiuSend;
@property (nonatomic, assign) ModelRemoteNotificationProfileStatus *objProfileStatusChange;

@end
