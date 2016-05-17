//
//  MBProgressHUD+plug.h
//  IMeetU
//
//  Created by zhanghao on 16/3/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBProgressHUD(plug)

+ (instancetype)xmShowHUDAddedTo:(UIView *)view animated:(BOOL)animated;

+ (instancetype)xmShowIndeterminateHUDAddedTo:(UIView *)view label:(NSString*)label animated:(BOOL)animated;

- (void)xmSetCustomModeWithResult:(BOOL)res label:(NSString*)label;

@end
