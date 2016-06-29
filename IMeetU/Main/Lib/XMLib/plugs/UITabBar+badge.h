//
//  UITabBar+badge.h
//  IMeetU
//
//  Created by Spring on 16/6/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

/**
 *  显示自定义的小红点
 *
 *  @param index 显示的位置
 */
- (void)showBadgeOnItemIndex:(int)index;
/**
 *  隐藏自定义的小红点
 *
 *  @param index 隐藏位置
 */
- (void)hideBadgeOnItemIndex:(int)index;
@end
