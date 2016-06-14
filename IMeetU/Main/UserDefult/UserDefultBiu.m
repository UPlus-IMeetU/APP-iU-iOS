//
//  UserDefultBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultBiu.h"
#import "NSDate+plug.h"

@implementation UserDefultBiu

+ (BOOL)biuInMatch{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:BIU_IN_MATCH] boolValue];
}
+ (void)setBiuInMatch:(BOOL)inMatch{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:inMatch] forKey:BIU_IN_MATCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)biuUserProfileOfGrab{
    return [[NSUserDefaults standardUserDefaults] objectForKey:BIU_IN_MATCH_GRAB_PROFILE];
}
+ (void)setBiuUserProfileOfGrab:(NSString *)url{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:BIU_IN_MATCH_GRAB_PROFILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (long long)biuSendTime{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:BIU_SEND_TIME]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:BIU_SEND_TIME] longLongValue];
    }
    return 0;
}
+ (void)setBiuSendTime{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:[NSDate currentTimeMillis]] forKey:BIU_SEND_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)biuOvertime{
    long long biuSendTime = [UserDefultBiu biuSendTime];
    long long timeZone = ([NSDate currentTimeMillis] - biuSendTime) / 1000;
    if (timeZone >= 90) {
        return NO;
    }
    return YES;
}
@end
