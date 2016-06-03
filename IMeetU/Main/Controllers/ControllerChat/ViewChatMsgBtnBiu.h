//
//  ViewChatMsgBtnBiu.h
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewChatMsgBtnBiu : UIView

+ (instancetype)viewWithCallback:(void(^)())callback;

- (void)setNumber:(NSInteger)number;

@end
