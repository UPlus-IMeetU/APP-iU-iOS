//
//  ControllerBiuAccept.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuAccept.h"
#import "UIStoryboard+Plug.h"

@interface ControllerBiuAccept ()

@end

@implementation ControllerBiuAccept

+ (instancetype)controller{
    ControllerBiuAccept *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"ControllerBiuAccept"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
