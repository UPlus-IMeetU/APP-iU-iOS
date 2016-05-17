//
//  ControllerMineAlterInterest.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelInterests.h"

@protocol ControllerMineAlterInterestDelegate;

@interface ControllerMineAlterInterest : UIViewController

@property (nonatomic, weak) id<ControllerMineAlterInterestDelegate> delegateAlterInterest;

+ (instancetype)controllerWithInterests:(NSArray*)interests;

@end
@protocol ControllerMineAlterInterestDelegate <NSObject>
@optional
- (void)controllerMineAlterInterest:(ControllerMineAlterInterest*)controller selecteds:(NSArray*)selecteds;

@end
