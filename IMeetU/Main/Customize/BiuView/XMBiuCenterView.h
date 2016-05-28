//
//  XMBiuCenterButton.h
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelBiuFaceStar.h"

@protocol XMBiuCenterButtonDelegate;

@interface XMBiuCenterView : UIView

@property (nonatomic, weak) id<XMBiuCenterButtonDelegate> delegateBiuCenter;

+ (instancetype)biuCenterButtonWithOrigin:(CGPoint)origin;

- (void)noReceiveMatchUser;

- (void)receiveMatcheUserWithImageUrl:(NSString*)url;
//- (void)receiveMatcheUserWithModel:(ModelBiuFaceStar*)model animation:(BOOL)animation;

- (void)timerCountdownStart;

@end
@protocol XMBiuCenterButtonDelegate <NSObject>
@optional
- (void)biuCenterButton:(XMBiuCenterView*)biuCenterButton onClickBtnSenderBiu:(UIButton*)btn isTimeout:(BOOL)timeout;
- (void)biuCenterButton:(XMBiuCenterView*)biuCenterButton onClickBtnSuccessfulMatches:(UIButton*)btn model:(ModelBiuFaceStar*)model;
//倒计时结束回调
- (void)biuCenterButtonCountdownEnd:(XMBiuCenterView*)biuCenterButton;
@end