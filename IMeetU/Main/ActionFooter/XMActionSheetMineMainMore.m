//
//  XMActionSheetMineMainMore.m
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMActionSheetMineMainMore.h"
#import "UINib+Plug.h"

@interface XMActionSheetMineMainMore()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewActionSheetBootom;
@property (weak, nonatomic) IBOutlet UIView *viewActionSheet;

@end
@implementation XMActionSheetMineMainMore

+ (UIView *)actionSheet{
    XMActionSheetMineMainMore *actioSheet = [UINib xmViewWithName:[XMActionSheet nibName] class:[XMActionSheetMineMainMore class]];
    
    return actioSheet;
}

- (CGFloat)sheetHeight{
    return 92;
}

- (UIView *)actionSheet{
    return self.viewActionSheet;
}

- (NSLayoutConstraint *)constraintActionSheetBootom{
    return self.constraintViewActionSheetBootom;
}

- (IBAction)onClickBtnReport:(id)sender {
    if (self.delegateActionSheet) {
        if ([self.delegateActionSheet respondsToSelector:@selector(xmActionSheetMineMainMoreReport:)]) {
            [self.delegateActionSheet xmActionSheetMineMainMoreReport:self];
        }
    }
}

- (IBAction)onClickBtnCancel:(id)sender {
    if (self.delegateActionSheet) {
        if ([self.delegateActionSheet respondsToSelector:@selector(xmActionSheetMineMainMoreCancel:)]) {
            [self.delegateActionSheet xmActionSheetMineMainMoreCancel:self];
        }
    }
}

@end
