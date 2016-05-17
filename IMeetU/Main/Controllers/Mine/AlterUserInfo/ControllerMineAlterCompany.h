//
//  ControllerMineAlterICompany.h
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerMineAlterCompanyDelegate;

@interface ControllerMineAlterCompany : UIViewController

@property (nonatomic, weak) id<ControllerMineAlterCompanyDelegate> delegateAlterCompany;
+ (instancetype)controllerWithCompany:(NSString*)company;

@end
@protocol ControllerMineAlterCompanyDelegate <NSObject>
@optional
- (void)controllerMineAlterCompany:(ControllerMineAlterCompany*)controller company:(NSString*)company;

@end
