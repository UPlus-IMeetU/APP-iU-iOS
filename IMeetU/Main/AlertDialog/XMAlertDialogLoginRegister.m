//
//  XMAlertDialogLoginRegister.m
//  IMeetU
//
//  Created by zhanghao on 16/3/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMAlertDialogLoginRegister.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"

@interface XMAlertDialogLoginRegister()

@property (weak, nonatomic) IBOutlet UIView *viewAlertDialog;
@property (weak, nonatomic) IBOutlet UILabel *labelDialogTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;


@end
@implementation XMAlertDialogLoginRegister

+ (instancetype)viewWithTitle:(NSString *)title delegate:(id<XMAlertDialogLoginRegisterDelegate>)delegate{
    XMAlertDialogLoginRegister *view = [UINib xmViewWithName:[XMAlertDialog nibName] class:[XMAlertDialogLoginRegister class]];
    view.labelDialogTitle.text = title;
    view.delegateAlertDialog = delegate;
    
    return view;
}

- (void)awakeFromNib{
    self.viewAlertDialog.layer.cornerRadius = 5;
    self.viewAlertDialog.layer.masksToBounds = YES;
}

- (void)showWithSuperView:(UIView *)superView{
    self.alpha = 0;
    self.frame = superView.bounds;
    [superView addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (IBAction)onClickBtnCancle:(id)sender {
    if (self.delegateAlertDialog) {
        if ([self.delegateAlertDialog respondsToSelector:@selector(xmAlertDialogLoginRegister:onClickBtnCancel:)]) {
            [self.delegateAlertDialog xmAlertDialogLoginRegister:self onClickBtnCancel:sender];
        }
    }
}

- (IBAction)onClickBtnConfirm:(id)sender {
    if (self.delegateAlertDialog) {
        if ([self.delegateAlertDialog respondsToSelector:@selector(xmAlertDialogLoginRegister:onClickBtnConfirm:)]) {
            [self.delegateAlertDialog xmAlertDialogLoginRegister:self onClickBtnConfirm:sender];
        }
    }
}


@end
