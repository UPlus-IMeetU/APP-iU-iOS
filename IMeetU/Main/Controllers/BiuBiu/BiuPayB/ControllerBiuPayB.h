//
//  ControllerBiuPayB.h
//  IMeetU
//
//  Created by zhanghao on 16/3/24.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerBiuPayBDelegate;

@interface ControllerBiuPayB : UIViewController

@property (nonatomic, weak) id<ControllerBiuPayBDelegate> delegatePayUmi;
+ (instancetype)controllerWithUmiCount:(NSInteger)count;


@end
@protocol ControllerBiuPayBDelegate <NSObject>
@optional
- (void)controllerBiuPayB:(ControllerBiuPayB*)controller payRes:(BOOL)res umiCount:(NSInteger)count;

@end