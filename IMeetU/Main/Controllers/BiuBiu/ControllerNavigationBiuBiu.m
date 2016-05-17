//
//  ControllerNavigationBiuBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/3/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerNavigationBiuBiu.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

#import "ControllerDrawer.h"
#import "ControllerBiuBiu.h"

@interface ControllerNavigationBiuBiu ()
@end

@implementation ControllerNavigationBiuBiu

+ (instancetype)shareControllerNavigationBiuBiu{
    static ControllerNavigationBiuBiu *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[ControllerNavigationBiuBiu alloc] init];
        controller.navigationBarHidden = YES;
        [controller initial];
    });
    
    return controller;
}

- (void)initial{
    [self pushViewController:[ControllerBiuBiu shareControllerBiuBiu] animated:NO];
}

@end
