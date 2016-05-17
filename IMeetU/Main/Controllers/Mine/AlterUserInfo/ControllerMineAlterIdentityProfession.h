//
//  ControllerMineAlterIdentity.h
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerMineAlterIdentityProfessionDelegate;

@interface ControllerMineAlterIdentityProfession : UIViewController

@property (nonatomic, weak) UIViewController *previousController;
@property (nonatomic, weak) id<ControllerMineAlterIdentityProfessionDelegate> delegateAlterIdentityProfession;

+ (instancetype)controllerWithProfession:(NSString*)profession isGraduated:(NSInteger)isGraduated;

@end
@protocol ControllerMineAlterIdentityProfessionDelegate <NSObject>
@optional
- (void)controllerMineAlterIdentityProfession:(ControllerMineAlterIdentityProfession*)controller isGraduated:(NSInteger)isGraduated profession:(NSString*)profession schoolId:(NSString*)schoolId schoolName:(NSString*)schoolName;


@end
