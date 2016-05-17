//
//  ModelUserListMatch.h
//  IMeetU
//
//  Created by zhanghao on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelUserListMatch : NSObject

/**
 * 显示头像的最大间隔时间
 */
@property (nonatomic, assign) NSInteger showIntervalMax;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong) NSArray *users;

@end
