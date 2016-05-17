//
//  XMAlertDialogUnfriendYou.h
//  IMeetU
//
//  Created by zhanghao on 16/3/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMAlertDialog.h"

@protocol XMAlertDialogUnfriendYouDelegate;

@interface XMAlertDialogUnfriendYou : XMAlertDialog

@property (nonatomic, weak) id<XMAlertDialogUnfriendYouDelegate> delegateAlertDialog;
+ (instancetype)alertDialogWithIndexPath:(NSIndexPath*)indexPath;

@end
@protocol XMAlertDialogUnfriendYouDelegate <NSObject>
- (void)xmAlertDialogUnfriendYouOn:(XMAlertDialogUnfriendYou*)view indexPath:(NSIndexPath*)indexPath;

- (void)xmAlertDialogUnfriendYouCancel:(XMAlertDialogUnfriendYou*)view indexPath:(NSIndexPath*)indexPath;

@end