//
//  UserDefultMsg.m
//  IMeetU
//
//  Created by zhanghao on 16/4/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultMsg.h"

#define UnreadMsgCount @"UserDefultMsgUnreadMsgCount"

@implementation UserDefultMsg

+ (NSInteger)unreadMsgCount{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UnreadMsgCount] integerValue];
}

+ (void)unreadMsgCountIncrease{
    NSInteger unreadCount = [[[NSUserDefaults standardUserDefaults] objectForKey:UnreadMsgCount] integerValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:unreadCount+1] forKey:UnreadMsgCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)unreadMsgCountReduceWithCount:(NSInteger)count{
    NSInteger unreadCount = [[[NSUserDefaults standardUserDefaults] objectForKey:UnreadMsgCount] integerValue];
    unreadCount = unreadCount-count;
    unreadCount = unreadCount>0?unreadCount:0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:unreadCount] forKey:UnreadMsgCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)unreadMsgCountReset{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UnreadMsgCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
