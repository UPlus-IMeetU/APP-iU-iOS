//
//  ModelUserMatch.h
//  IMeetU
//
//  Created by zhanghao on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUserMatch : NSObject

/**
 * 用户code
 */
@property (nonatomic, assign) NSInteger userCode;
/**
 * 昵称
 */
@property (nonatomic, copy) NSString *nameNick;
/**
 * 用户头像缩略图
 */
@property (nonatomic, copy) NSString *urlProfileThumbnail;
/**
 * 用户年龄
 */
@property (nonatomic, assign) NSInteger age;
/**
 * 用户性别
 */
@property (nonatomic, assign) NSInteger gender;
/**
 * 星座
 */
@property (nonatomic, copy) NSString *constellation;
/**
 * 学校id
 */
@property (nonatomic, assign) NSInteger schoolID;
/**
 * 匹配度
 */
@property (nonatomic, assign) NSInteger matchScore;
/**
 * 相对我的距离
 */
@property (nonatomic, assign) NSInteger distanceToMe;
/**
 * 发biubiu时间
 */
@property (nonatomic, assign) long long timeSendBiu;
/**
 * 发biubiu的话题
 */
@property (nonatomic, copy) NSString *topic;
/**
 * 是否已经在屏幕上显示过
 */
@property (nonatomic, assign) BOOL isShow;

@end
