//
//  UserDefultDB.m
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultDB.h"
#import "NSDate+plug.h"

@implementation UserDefultDB

+ (NSInteger)finalUpdateTimeContact{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"finalUpdateTimeContact"] integerValue];
}

+ (void)finalUpdateTimeContactUpdate{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[NSDate currentTimeMillisSecond]] forKey:@"finalUpdateTimeContact"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)finalUpdateTimeContactTimeout{
    NSInteger updateTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"finalUpdateTimeContact"] integerValue];
    NSLog(@"=====>%lu", [NSDate currentTimeMillisSecond] - updateTime);
    return [NSDate currentTimeMillisSecond] - updateTime > 60;
}
@end
