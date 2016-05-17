//
//  ControllerMatchSetting.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ControllerType) {
    ControllerTypeFilter,
    ControllerTypeSetUp
};
@interface ControllerMatchSetting : UIViewController

@property (nonatomic,assign) ControllerType controllerType;
+ (instancetype)controller;

@end
