//
//  ControllerTabBarMain.h
//  IMeetU
//
//  Created by zhanghao on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControllerTabBarMain : UITabBarController

+ (instancetype)shareController;

/**
 *  设置未读总消息数
 *
 *  @param badge 总未读消息数
 */
+ (void)setBadgeMsgWithCount:(NSInteger)badge;

+ (void)setBadgeCommunityWithIsShow:(BOOL)isShow;

- (void)showBadgeWithIndex:(NSInteger)index;
- (void)hideBadgeWithIndex:(NSInteger)index;

- (void)loginOrRegister;
@end
