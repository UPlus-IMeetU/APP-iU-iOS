//
//  MLStructWrap.h
//  MeetU
//
//  Created by zhanghao on 15/8/25.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLStructWrap : NSObject


+ (CGRect)resetRectX:(CGRect)rect newX:(float)x;

#pragma mark - 结构的某些属性在原有的基础上，上下浮动
//结构的x值在原有基础上浮动
+ (CGRect)floatRectX:(CGRect)rect floatX:(float)x;

/*
CG_INLINE CGRect
FloatRectX(CGRect rect, float x);
*/

@end
