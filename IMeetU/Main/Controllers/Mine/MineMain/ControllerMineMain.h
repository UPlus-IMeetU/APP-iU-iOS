//
//  ControllerMineMain.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MineMainGetUserCodeFrom) {
    MineMainGetUserCodeFromParam,
    MineMainGetUserCodeFromUserDefult
};

@interface ControllerMineMain : UIViewController
+ (instancetype)controllerWithUserCode:(NSString*)userCode getUserCodeFrom:(MineMainGetUserCodeFrom)getUserCodeFrom;


- (void)loadUserInfo:(NSString *)userCode;
@end
