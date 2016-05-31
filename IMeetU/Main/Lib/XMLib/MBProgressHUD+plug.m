//
//  MBProgressHUD+plug.m
//  IMeetU
//
//  Created by zhanghao on 16/3/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "MBProgressHUD+plug.h"
#import "UIColor+Plug.h"

@implementation MBProgressHUD(plug)

+ (instancetype)xmShowHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.color = [UIColor colorWithR:0 G:0 B:0 A:0.7];
    hud.minSize = CGSizeMake(100, 100);
    
    return hud;
}

+ (instancetype)xmShowIndeterminateHUDAddedTo:(UIView *)view label:(NSString*)label animated:(BOOL)animated{
    MBProgressHUD *hud = [MBProgressHUD xmShowHUDAddedTo:view animated:animated];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (label && label.length>0) {
        hud.labelText = label;
    }
    return hud;
}

- (void)xmSetCustomModeWithResult:(BOOL)res label:(NSString*)label{
    self.mode = MBProgressHUDModeCustomView;
    if (res) {
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mbhud_yes"]];
    }else{
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mbhud_no"]];
    }
    if (label && label.length>0) {
        self.labelText = label;
    }
}

@end
