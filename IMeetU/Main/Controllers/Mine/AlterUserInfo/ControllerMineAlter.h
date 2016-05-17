//
//  ControllerMineAlter.h
//  MeetU
//
//  Created by zhanghao on 15/8/17.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ControllerMineAlterDelegate;
@interface ControllerMineAlter : UIViewController

@property (nonatomic, strong) id<ControllerMineAlterDelegate> delegateControllerMineAlter;

@end
@protocol ControllerMineAlterDelegate <NSObject>
@optional
- (void)controllerMineAlterSaveSuccess;

@end