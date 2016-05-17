//
//  ControllerMineAlterConstellation.h
//  MeetU
//
//  Created by zhanghao on 15/8/17.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllerMineAlter.h"

@protocol ControllerMineAlterConstellationDelegate;

@interface ControllerMineAlterConstellation : ControllerMineAlter

@property (nonatomic, weak) id<ControllerMineAlterConstellationDelegate> delegateAlterConstellation;
+ (instancetype)controllerMineAlterConstellation:(NSString*)constellation birthday:(NSDate*)birthday;

@end
@protocol ControllerMineAlterConstellationDelegate <NSObject>
@optional
- (void)controllerMineAlterConstellation:(ControllerMineAlterConstellation*)controller constellation:(NSString*)constellation;

@end