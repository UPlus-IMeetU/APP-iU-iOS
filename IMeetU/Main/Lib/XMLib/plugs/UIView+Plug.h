//
//  UIView+Plug.h
//  MeetU_iOS
//
//  Created by zhanghao on 15/7/20.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView(Plug)
/**
 *  此方法是操作frame的快速方法
 *
 *  @param x      view在x轴的位移
 *  @param y      view在y轴的位移
 *  @param width  view的宽度的变化，width为正，宽度增大，width为负，宽度减小
 *  @param height view的高度的变化
 */
-(void)changeWithX:(float)x y:(float)y width:(float)width height:(float)height;
/**
 *  切圆角
 *
 *  @param cornerRadius 圆角半径
 */
- (void)clipCorner:(CGFloat)cornerRadius;
/**
 *  切圆角
 *
 *  @param cornerRadius 圆角半径
 *  @param size         视图尺寸
 *  @param corners      切那几个角
 */
- (void)clipCorner:(CGFloat)cornerRadius viewSize:(CGSize)size byRoundingCorners:(UIRectCorner)corners;

- (void)addCliclkListenerToSelf;

- (void)onClickSelfWithTapGestureRecognizer:(UITapGestureRecognizer*)tapGestureRecognizer;
/**
 *  点击动画
 */
- (void)startDuangAnimation;
/**
 *  转场动画
 */
- (void)startTransitionAnimation;

@end
