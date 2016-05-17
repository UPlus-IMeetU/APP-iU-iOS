//
//  ViewChatMsgImgBrowser.h
//  IMeetU
//
//  Created by zhanghao on 16/4/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMessageModel.h"

@interface ViewChatMsgImgBrowser : UIView

+ (instancetype)instanceViewWithAllMsgs:(NSArray*)allMsgs msg:(id<IMessageModel>)messageModel;

- (void)showInView:(UIView*)view;

@end
