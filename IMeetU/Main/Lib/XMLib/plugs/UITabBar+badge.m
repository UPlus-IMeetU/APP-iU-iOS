//
//  UITabBar+badge.m
//  IMeetU
//
//  Created by Spring on 16/6/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItmeNums 4.0

@implementation UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
    
    UIView *badgeView = [UIView new];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    float percentX = (index + 0.6) / TabbarItmeNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
}


- (void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index{
    for(UIView *subView in self.subviews){
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}
@end
