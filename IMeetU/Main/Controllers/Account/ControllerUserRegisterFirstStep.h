//
//  ControllerRegister.h
//  IMeetU
//
//  Created by zhanghao on 16/3/6.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelRequestRegister;

@interface ControllerUserRegisterFirstStep : UIViewController

+ (instancetype)controllerWithModel:(ModelRequestRegister*)modelRequestRegister profile:(UIImage*)profile;

@end
