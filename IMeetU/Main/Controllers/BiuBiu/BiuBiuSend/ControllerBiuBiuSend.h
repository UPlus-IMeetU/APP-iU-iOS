//
//  ControllerBiuBiuSend.h
//  IMeetU
//
//  Created by zhanghao on 16/3/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerBiuBiuSendDelegate;

@interface ControllerBiuBiuSend : UIViewController

@property (nonatomic, weak) id<ControllerBiuBiuSendDelegate> delegateBiuSender;
+ (instancetype)shareController;

@end
@protocol ControllerBiuBiuSendDelegate <NSObject>
@optional
/**
 *  发送biubiu回调
 *
 *  @param controller <#controller description#>
 *  @param result     发送结果
 */
- (void)controllerBiuBiuSend:(ControllerBiuBiuSend*)controller sendResult:(BOOL)result virtualCurrency:(NSInteger)virtualCurrency;

@end