//
//  UserDefultAppGlobalStatus.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultAppGlobalStatus.h"
#import "ControllerTabBarMain.h"

@implementation UserDefultAppGlobalStatus

+ (void)setCountOfNoticeCommunity:(NSInteger)count{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:AppGlobalStatusCountOfNiticeComm];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)resetCountOfNoticeCommunity{
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:AppGlobalStatusCountOfNiticeComm];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSInteger)countOfNoticeCommunity{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:AppGlobalStatusCountOfNiticeComm] integerValue];
}


+ (void)setCountOfBiuMe:(NSInteger)count{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:AppGlobalStatusCountOfBiuMe];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ControllerTabBarMain setBadgeCommunityWithIsShow:YES];
}
+ (void)resetCountOfBiuMe{
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:AppGlobalStatusCountOfBiuMe];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ControllerTabBarMain setBadgeCommunityWithIsShow:NO];
}
+ (NSInteger)countOfBiuMe{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:AppGlobalStatusCountOfBiuMe] integerValue];
}

@end
