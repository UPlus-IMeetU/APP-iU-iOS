//
//  XMActionSheetChatMsg.m
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMActionSheetChatMsg.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"

@interface XMActionSheetChatMsg()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewActionSheetBootom;
@property (weak, nonatomic) IBOutlet UIView *viewActionSheet;

@end
@implementation XMActionSheetChatMsg

+ (instancetype)actionSheet{
    XMActionSheetChatMsg *actionSheet = [UINib xmViewWithName:[XMActionSheet nibName] class:[XMActionSheetChatMsg class]];
    
    return actionSheet;
}

- (CGFloat)sheetHeight{
    return 221;
}

- (UIView *)actionSheet{
    return self.viewActionSheet;
}

- (NSLayoutConstraint *)constraintActionSheetBootom{
    return self.constraintViewActionSheetBootom;
}

- (IBAction)onClickBtnReadHisMine:(UIButton*)sender {
    if (self.delegateActionSheet) {
        if ([self.delegateActionSheet respondsToSelector:@selector(xmActionSheetChatMsgReadHisMine:)]) {
            [self.delegateActionSheet xmActionSheetChatMsgReadHisMine:self];
        }
    }
}

- (IBAction)onClickBtnCleanChatRecord:(UIButton*)sender {
    if (self.delegateActionSheet) {
        if ([self.delegateActionSheet respondsToSelector:@selector(xmActionSheetChatMsgCleanChatRecord:)]) {
            [self.delegateActionSheet xmActionSheetChatMsgCleanChatRecord:self];
        }
    }
}

- (IBAction)onClickBtnToReport:(UIButton*)sender {
    if (self.delegateActionSheet) {
        if ([self.delegateActionSheet respondsToSelector:@selector(xmActionSheetChatMsgToReport:)]) {
            [self.delegateActionSheet xmActionSheetChatMsgToReport:self];
        }
    }
}

- (IBAction)onClickBtnUnfriendYou:(UIButton*)sender {
    if (self.delegateActionSheet) {
        if ([self.delegateActionSheet respondsToSelector:@selector(xmActionSheetChatMsgUnfriendYou:)]) {
            [self.delegateActionSheet xmActionSheetChatMsgUnfriendYou:self];
        }
    }
}

- (IBAction)onClickBtnCancel:(UIButton*)sender {
    if (self.delegateActionSheet) {
        if ([self.delegateActionSheet respondsToSelector:@selector(xmActionSheetChatMsgCancel:)]) {
            [self.delegateActionSheet xmActionSheetChatMsgCancel:self];
        }
    }
}

@end
