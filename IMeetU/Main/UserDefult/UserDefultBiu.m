//
//  UserDefultBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UserDefultBiu.h"

@implementation UserDefultBiu

+ (BOOL)biuInMatch{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:BIU_IN_MATCH] boolValue];
}
+ (void)setBiuInMatch:(BOOL)inMatch{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:inMatch] forKey:BIU_IN_MATCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
