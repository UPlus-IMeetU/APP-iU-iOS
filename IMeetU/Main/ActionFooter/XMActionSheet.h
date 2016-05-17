//
//  XMActionSheet.h
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMActionSheet : UIView

@property (nonatomic, assign) CGFloat sheetHeight;
@property (nonatomic, strong) UIView *actionSheet;
@property (nonatomic, strong) NSLayoutConstraint *constraintActionSheetBootom;

+ (instancetype)actionSheet;

+ (NSString *)nibName;

- (void)initial;

- (void)showInView:(UIView*)view;

- (void)hiddenAndDestory;
- (void)hiddenAndDestoryWithCompletion:(void(^)(BOOL finish))completion;
@end
