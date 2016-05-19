//
//  UserDefultDB.h
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefultDB : NSObject

@property (nonatomic, assign, readonly) NSInteger finalUpdateTimeContact;
/**
 *  更新最后更新时间
 */
+ (void)finalUpdateTimeContactUpdate;
/**
 *  检查超时
 */
+ (BOOL)finalUpdateTimeContactTimeout;

@end
