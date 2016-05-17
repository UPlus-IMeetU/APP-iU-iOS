//
//  XMAlertDialogRealProfile.m
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMAlertDialogRealProfile.h"

#import "XMNibStoryboardFilesName.h"
#import "UINib+Plug.h"
#import "UIView+Plug.h"

@interface XMAlertDialogRealProfile()

@property (weak, nonatomic) IBOutlet UIView *viewAlterDialog;

@end
@implementation XMAlertDialogRealProfile

+ (instancetype)alertDialog{
    XMAlertDialogRealProfile *alertDialog = [UINib xmViewWithName:[XMAlertDialog nibName] class:[XMAlertDialogRealProfile class]];
    
    return alertDialog;
}

- (void)awakeFromNib{
    self.viewAlterDialog.layer.cornerRadius = 10;
    self.viewAlterDialog.layer.masksToBounds = YES;
}

- (void)showWithSuperView:(UIView *)superView{
    [self addCliclkListenerToSelf];
    
    self.alpha = 0;
    self.frame = superView.bounds;
    [superView addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)hiddenAndRemove{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)onClickBtnUnderstand:(id)sender {
    if (self.delegateAlertDialog) {
        if ([self.delegateAlertDialog respondsToSelector:@selector(xmAlertDialogRealProfileOnClick:)]) {
            [self.delegateAlertDialog xmAlertDialogRealProfileOnClick:self];
        }
    }
}

- (void)onClickSelfWithTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self hiddenAndRemove];
}

@end
