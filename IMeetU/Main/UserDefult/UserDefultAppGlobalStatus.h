//
//  UserDefultAppGlobalStatus.h
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefult.h"

@interface UserDefultAppGlobalStatus : UserDefult

/**
 *  帖子通知数量相关状态
 */
+ (void)setCountOfNoticeCommunity:(NSInteger)count;
+ (void)resetCountOfNoticeCommunity;
+ (NSInteger)countOfNoticeCommunity;

/**
 *  biu我的人的数量相关状态
 */
+ (void)setCountOfBiuMe:(NSInteger)count;
+ (void)resetCountOfBiuMe;
+ (NSInteger)countOfBiuMe;
@end
