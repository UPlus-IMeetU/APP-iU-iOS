//
//  UserDefultBiu.h
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefult.h"

@interface UserDefultBiu : UserDefult

//biubiu是否正在匹配
+ (BOOL)biuInMatch;
+ (void)setBiuInMatch:(BOOL)inMatch;
//最后一个抢biu的人的头像
+ (NSString*)biuUserProfileOfGrab;
+ (void)setBiuUserProfileOfGrab:(NSString*)url;

+ (long long)biuSendTime;
+ (void)setBiuSendTime;
+ (BOOL)biuOvertime;
@end
