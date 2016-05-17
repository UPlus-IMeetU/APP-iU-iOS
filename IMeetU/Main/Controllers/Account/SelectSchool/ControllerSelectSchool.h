//
//  ControllerViewSelectSchool.h
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerSelectSchoolDelegate;

@interface ControllerSelectSchool : UIViewController

+(instancetype)controllerViewSelectSchool;

@property (nonatomic, weak) id<ControllerSelectSchoolDelegate> delegateSelegateSchool;

@end
@protocol ControllerSelectSchoolDelegate <NSObject>
@optional
- (void)controllerSelectSchool:(ControllerSelectSchool*)controller schoolName:(NSString*)schoolName schoolId:(NSString*)schoolId;
@end