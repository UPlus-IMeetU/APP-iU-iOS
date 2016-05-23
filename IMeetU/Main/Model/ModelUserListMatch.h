//
//  ModelUserListMatch.h
//  IMeetU
//
//  Created by zhanghao on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelUserListMatch : NSObject

@property (nonatomic, copy) NSString *token;
/**
 * 是否还有匹配的用户
 */
@property (nonatomic, assign) int hasNext;
/**
 * 显示头像的最大间隔时间
 */
@property (nonatomic, assign) NSInteger showIntervalMax;
/**
 * 显示头像的最小间隔时间
 */
@property (nonatomic, assign) NSInteger showIntervalMin;

@property (nonatomic, strong) NSArray *users;

@end
