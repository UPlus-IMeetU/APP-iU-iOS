//
//  UserDefultMsg.h
//  IMeetU
//
//  Created by zhanghao on 16/4/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefultMsg : NSObject

+ (void)unreadMsgCountIncrease;

+ (void)unreadMsgCountReduceWithCount:(NSInteger)count;

+ (NSInteger)unreadMsgCount;

+ (void)unreadMsgCountReset;

@end
