//
//  ControllerMineAlterBodyHeightWeight.h
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerMineAlterBodyHeightWeightDelegate;

@interface ControllerMineAlterBodyHeightWeight : UIViewController

@property (nonatomic, weak) id<ControllerMineAlterBodyHeightWeightDelegate> delegateAlterBodyHeightWeight;
+ (instancetype)controllerWithHeight:(NSInteger)height weight:(NSInteger)weight;

@end
@protocol ControllerMineAlterBodyHeightWeightDelegate <NSObject>
@optional
- (void)controllerMineAlterBodyHeightWeight:(ControllerMineAlterBodyHeightWeight*)controller height:(NSInteger)height weight:(NSInteger)weight;

@end
