//
//  ControllerMyAlterName.h
//  MeetU
//
//  Created by zhanghao on 15/8/13.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerMineAlter.h"

@protocol ControllerMineAlterNameDelegate;

@interface ControllerMineAlterName : ControllerMineAlter

@property (nonatomic, weak) id<ControllerMineAlterNameDelegate> delegateAlterName;

+(instancetype)controllerMyAlterName:(NSString*)nameNick;

@end
@protocol ControllerMineAlterNameDelegate <NSObject>
@optional
- (void)controllerMineAlterName:(ControllerMineAlterName*)controller nameNick:(NSString*)nameNick;

@end