//
//  XMAlertDialogLoginRegister.h
//  IMeetU
//
//  Created by zhanghao on 16/3/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMAlertDialog.h"

@protocol XMAlertDialogLoginRegisterDelegate;

@interface XMAlertDialogLoginRegister : XMAlertDialog

@property (nonatomic, weak) id<XMAlertDialogLoginRegisterDelegate> delegateAlertDialog;
+ (instancetype)viewWithTitle:(NSString*)title delegate:(id<XMAlertDialogLoginRegisterDelegate>)delegate;
@end
@protocol XMAlertDialogLoginRegisterDelegate <NSObject>
@optional
- (void)xmAlertDialogLoginRegister:(XMAlertDialogLoginRegister*)view onClickBtnCancel:(UIButton*)sender;

- (void)xmAlertDialogLoginRegister:(XMAlertDialogLoginRegister*)view onClickBtnConfirm:(UIButton*)sender;

@end
