//
//  XMAlertDialog.m
//  IMeetU
//
//  Created by zhanghao on 16/3/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMAlertDialog.h"
#import "UIView+Plug.h"

@interface XMAlertDialog()

@end
@implementation XMAlertDialog

+ (NSString *)nibName{
    return @"XMAlertDialog";
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

- (void)onClickSelfWithTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self hiddenAndRemove];
}

@end
