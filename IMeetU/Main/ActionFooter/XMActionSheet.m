//
//  XMActionSheet.m
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMActionSheet.h"
#import "UIColor+Plug.h"
#import <YYKit/YYKit.h>

@implementation XMActionSheet

+ (instancetype)actionSheet{
    return [[XMActionSheet alloc] init];
}

- (void)awakeFromNib{
    [self initial];
}

- (void)initial{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self hiddenAndDestory];
    }];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)showInView:(UIView *)view{
    
    [view addSubview:self];
    self.frame = view.bounds;
    self.actionSheet.alpha = 0;
    self.constraintActionSheetBootom.constant = -self.sheetHeight;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        self.actionSheet.alpha = 1;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.2];
            self.constraintActionSheetBootom.constant = 0;
            [self layoutSubviews];
        }];
    }];
}

- (void)hiddenAndDestory{
    [self hiddenAndDestoryWithCompletion:nil];
}

- (void)hiddenAndDestoryWithCompletion:(void(^)(BOOL finish))completion{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.constraintActionSheetBootom.constant = -self.sheetHeight;
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}

+ (NSString *)nibName{
    return @"XMActionSheet";
}

@end
