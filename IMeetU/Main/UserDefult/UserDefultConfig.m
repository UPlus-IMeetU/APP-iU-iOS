//
//  UserDefultConfig.m
//  IMeetU
//
//  Created by zhanghao on 16/4/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultConfig.h"
#import "NSDate+plug.h"

#define IS_ENABLE_PAY_TIMEOUT @"UserDefultConfigIsEnablePayTimeout"
#define IS_ENABLE_PAY @"UserDefultConfigIsEnablePay"

@implementation UserDefultConfig

+ (BOOL)isFirstLaunch{
    return ![[[NSUserDefaults standardUserDefaults] objectForKey:@"AppFirshLaunch"] boolValue];
}

+ (void)setNoFirshLaunch{
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"AppFirshLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isEnablePayTimeout{
    NSInteger time = [NSDate currentTimeMillisSecond];
    return (time - [[[NSUserDefaults standardUserDefaults] objectForKey:IS_ENABLE_PAY_TIMEOUT] integerValue]) > 60*60;
}
+ (void)isEnablePayTimeoutReset{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[NSDate currentTimeMillisSecond]] forKey:IS_ENABLE_PAY_TIMEOUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isEnablePay{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:IS_ENABLE_PAY] boolValue];
}
+ (void)isEnablePay:(BOOL)enable{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:enable] forKey:IS_ENABLE_PAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
