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
}
+ (void)resetCountOfBiuMe{
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:AppGlobalStatusCountOfBiuMe];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSInteger)countOfBiuMe{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:AppGlobalStatusCountOfBiuMe] integerValue];
}

+ (void)setComBiuCount:(NSInteger)count{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:GlobalStatusComBiuCount];
}

+ (void)resetComBiuCount{
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:GlobalStatusComBiuCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)comBiuCount{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:GlobalStatusComBiuCount] integerValue];
}

+ (void)setNoticeCount:(NSInteger)count{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:GlobalStatusNoticeBiuCount];
}

+ (void)resetNoticeCount{
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:GlobalStatusNoticeBiuCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)noticeCount{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:GlobalStatusNoticeBiuCount] integerValue];
}

@end
