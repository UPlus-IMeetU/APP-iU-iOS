//
//  ControllerMyAlterBirthday.h
//  MeetU
//
//  Created by zhanghao on 15/8/13.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerMineAlter.h"

@protocol ControllerMineAlterBirthdayDelegate;

@interface ControllerMineAlterBirthday : ControllerMineAlter

@property (nonatomic, weak) id<ControllerMineAlterBirthdayDelegate> delegateAlterBirthday;

+(instancetype)controllerMyAlterBirthdayWithDate:(NSDate*)birthday;

@end
@protocol ControllerMineAlterBirthdayDelegate <NSObject>
@optional
- (void)controllerMineAlterBirthday:(ControllerMineAlterBirthday*)controller birthday:(NSDate*)birthday;

@end
