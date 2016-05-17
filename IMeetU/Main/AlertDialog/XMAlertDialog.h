//
//  XMAlertDialog.h
//  IMeetU
//
//  Created by zhanghao on 16/3/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMAlertDialog : UIView

+ (NSString *)nibName;
- (void)showWithSuperView:(UIView*)superView;
- (void)hiddenAndRemove;

@end
