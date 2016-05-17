//
//  UserDefultConfig.h
//  IMeetU
//
//  Created by zhanghao on 16/4/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefultConfig : NSObject

+ (BOOL)isFirstLaunch;
+ (void)setNoFirshLaunch;

+ (BOOL)isEnablePayTimeout;
+ (void)isEnablePayTimeoutReset;

+ (BOOL)isEnablePay;
+ (void)isEnablePay:(BOOL)enable;
@end
