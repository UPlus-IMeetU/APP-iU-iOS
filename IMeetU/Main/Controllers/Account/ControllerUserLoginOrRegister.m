//
//  ControllerLoginOrRegister.m
//  IMeetU
//
//  Created by zhanghao on 16/3/6.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserLoginOrRegister.h"

#import "UIStoryboard+Plug.h"

@interface ControllerUserLoginOrRegister ()

@end

@implementation ControllerUserLoginOrRegister

+ (instancetype)shareController{
    static ControllerUserLoginOrRegister *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameAccount indentity:@"ControllerUserLoginOrRegister"];
    });
    
    return controller;
}


- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
