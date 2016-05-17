//
//  ControllerDrawer.m
//  IMeetU
//
//  Created by zhanghao on 16/3/3.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerDrawer.h"
#import "MMDrawerVisualState.h"

#import "ControllerBiuBiu.h"
#import "ControllerNavigationBiuBiu.h"

#import "ControllerDrawerLeft.h"
#import "ControllerDrawerRight.h"

#import "UIScreen+Plug.h"

@interface ControllerDrawer ()

@end

@implementation ControllerDrawer

+ (instancetype)shareControllerDrawer{
    static ControllerDrawer *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[ControllerDrawer alloc] init];
        [controller initial];
    });
    
    return controller;
}

- (void)initial{
    self.centerViewController = [ControllerNavigationBiuBiu shareControllerNavigationBiuBiu];
//    self.leftDrawerViewController = [ControllerDrawerLeft controller];
//    self.rightDrawerViewController = [ControllerDrawerRight controller];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置打开模式
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //设置关闭模式
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //设置是否显示阴影
    [self setShowsShadow:YES];
    
    //设置最大滑开宽度（左）
    //[self setMaximumLeftDrawerWidth:100];
    
    [self setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNavigationBarOnly];
    
    //关闭模式（直接关闭）
    [self setCenterViewController:self.centerViewController withCloseAnimation:YES completion:^(BOOL finished) {}];
    //关闭模式（满屏关闭）
    [self setCenterViewController:self.centerViewController withFullCloseAnimation:YES completion:^(BOOL finished) {}];
    
    [self setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2]];
}

- (CGFloat)maximumLeftDrawerWidth{
    return 0;
}

- (CGFloat)maximumRightDrawerWidth{
    return 0;
}

@end
