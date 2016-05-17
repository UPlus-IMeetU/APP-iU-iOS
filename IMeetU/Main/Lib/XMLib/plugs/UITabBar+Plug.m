//
//  UITabBar+Plug.m
//  MeetU
//
//  Created by zhanghao on 15/8/19.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UITabBar+Plug.h"

@implementation UITabBar(Plug)

- (CGRect)tabBarFrameShow{
    return CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (CGRect)tabBarFrameHidden{
    return CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
}

@end
