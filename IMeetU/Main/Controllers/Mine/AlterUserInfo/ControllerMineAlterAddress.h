//
//  ControllerMyAlterHometown.h
//  MeetU
//
//  Created by zhanghao on 15/8/13.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerMineAlter.h"

@protocol ControllerMineAlterAddressDelegate;

@interface ControllerMineAlterAddress : ControllerMineAlter

@property (nonatomic, weak) id<ControllerMineAlterAddressDelegate> delegateAlterAddress;
+(instancetype)controllerMyAlterAddress:(NSString*)addressId operateStr:(NSString*)operateStr;

@end
@protocol ControllerMineAlterAddressDelegate <NSObject>
@optional
- (void)controllerMineAlterAddress:(ControllerMineAlterAddress*)controller address:(NSString*)address addressId:(NSString*)addressId cityNum:(NSString*)cityNum operateStr:(NSString*)operateStr;

@end
