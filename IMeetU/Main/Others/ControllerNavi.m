//
//  ControllerNavi.m
//  IMeetU
//
//  Created by zhanghao on 16/5/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerNavi.h"

@interface ControllerNavi ()

@end

@implementation ControllerNavi

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    UIViewController *controller = [super popViewControllerAnimated:animated];
    
    if (self.viewControllers.count == 1) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    return controller;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray<UIViewController *> *controllers = [super popToViewController:viewController animated:animated];
    
    if (self.viewControllers.count == 1) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    return controllers;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    NSArray<UIViewController *> *controllers = [super popToRootViewControllerAnimated:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    return controllers;
}

@end
