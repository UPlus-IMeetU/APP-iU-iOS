//
//  XMAlertDialogRealProfile.h
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMAlertDialog.h"

@protocol XMAlertDialogRealProfileDelegate;

@interface XMAlertDialogRealProfile : XMAlertDialog

@property (nonatomic, weak) id<XMAlertDialogRealProfileDelegate> delegateAlertDialog;

+ (instancetype)alertDialog;

- (void)showWithSuperView:(UIView*)superView;

- (void)hiddenAndRemove;

@end
@protocol XMAlertDialogRealProfileDelegate <NSObject>
@optional
- (void)xmAlertDialogRealProfileOnClick:(XMAlertDialogRealProfile*)alertDialog;

@end