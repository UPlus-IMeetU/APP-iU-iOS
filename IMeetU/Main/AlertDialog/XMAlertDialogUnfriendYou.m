//
//  XMAlertDialogUnfriendYou.m
//  IMeetU
//
//  Created by zhanghao on 16/3/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMAlertDialogUnfriendYou.h"
#import "UINib+Plug.h"
@interface XMAlertDialogUnfriendYou()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIView *viewAlertDialog;

@end
@implementation XMAlertDialogUnfriendYou

+ (instancetype)alertDialogWithIndexPath:(NSIndexPath *)indexPath{
    XMAlertDialogUnfriendYou *alertDialog = [UINib xmViewWithName:[XMAlertDialog nibName] class:[XMAlertDialogUnfriendYou class]];
    alertDialog.indexPath = indexPath;
    
    return alertDialog;
}

- (void)awakeFromNib{
    self.viewAlertDialog.layer.cornerRadius = 6;
    self.viewAlertDialog.layer.masksToBounds = YES;
}

- (IBAction)onClickBtnUnfriendYou:(id)sender {
    if (self.delegateAlertDialog) {
        if ([self.delegateAlertDialog respondsToSelector:@selector(xmAlertDialogUnfriendYouOn:indexPath:)]) {
            [self.delegateAlertDialog xmAlertDialogUnfriendYouOn:self indexPath:self.indexPath];
        }
    }
}

- (IBAction)onClickBtnCancel:(id)sender {
    if (self.delegateAlertDialog) {
        if ([self.delegateAlertDialog respondsToSelector:@selector(xmAlertDialogUnfriendYouCancel:indexPath:)]) {
            [self.delegateAlertDialog xmAlertDialogUnfriendYouCancel:self indexPath:self.indexPath];
        }
    }
}

@end
