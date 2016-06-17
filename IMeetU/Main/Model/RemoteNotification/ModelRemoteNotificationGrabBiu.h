//
//  ModelRemoteNotificationGrabBiu.h
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelRemoteNotificationGrabBiu : NSObject

@property (nonatomic, copy) NSString *nameNick;
@property (nonatomic, assign) int userCode;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int gender;
@property (nonatomic, assign) int school;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) long long time;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, assign) int virtualBiuBi;
@property (nonatomic, copy) NSString *profileUrl;

@end
