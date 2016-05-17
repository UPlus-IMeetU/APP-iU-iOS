//
//  ControllerRegisterSecondStep.h
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelRequestRegister.h"

@interface ControllerUserRegisterSecondStep : UIViewController

+ (instancetype)controllerWithModel:(ModelRequestRegister*)modelRequestRegister profile:(UIImage*)profile;

@end
