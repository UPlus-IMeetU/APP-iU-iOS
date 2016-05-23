//
//  ControllerChatMsg.h
//  IMeetU
//
//  Created by zhanghao on 16/3/20.
//  Copyright © 2016年 zhanghao. All rights reserved.
//
#import "EaseMessageViewController.h"
#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"
@interface ControllerChatMsg : EaseMessageViewController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType backController:(UIViewController*)controller;

@end
