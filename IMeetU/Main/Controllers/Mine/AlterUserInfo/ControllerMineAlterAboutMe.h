//
//  ControllerMineAlterAboutMe.h
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerMineAlterAboutMeDelegate
;
@interface ControllerMineAlterAboutMe : UIViewController

@property (nonatomic, weak) id<ControllerMineAlterAboutMeDelegate> delegateAlterAboutMe;
+ (instancetype)controllerMineAlterAboutMe:(NSString*)aboutMe;

@end
@protocol ControllerMineAlterAboutMeDelegate <NSObject>
@optional
- (void)controllerMineAlterAboutMe:(ControllerMineAlterAboutMe*)controller aboutMe:(NSString*)aboutMe;

@end
