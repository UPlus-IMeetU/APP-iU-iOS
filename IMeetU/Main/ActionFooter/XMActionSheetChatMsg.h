//
//  XMActionSheetChatMsg.h
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMActionSheet.h"

@protocol XMActionSheetChatMsgDelegate;

@interface XMActionSheetChatMsg : XMActionSheet

@property (nonatomic, weak) id<XMActionSheetChatMsgDelegate> delegateActionSheet;

@end
@protocol XMActionSheetChatMsgDelegate <NSObject>
@optional
/**
 *  查看对方个人主页
 */
- (void)xmActionSheetChatMsgReadHisMine:(XMActionSheetChatMsg*)view;
/**
 *  清空聊天记录
 */
- (void)xmActionSheetChatMsgCleanChatRecord:(XMActionSheetChatMsg*)view;
/**
 *  举报
 */
- (void)xmActionSheetChatMsgToReport:(XMActionSheetChatMsg*)view;
/**
 *  解除关系
 */
- (void)xmActionSheetChatMsgUnfriendYou:(XMActionSheetChatMsg*)view;
/**
 *  取消
 */
- (void)xmActionSheetChatMsgCancel:(XMActionSheetChatMsg*)view;
@end