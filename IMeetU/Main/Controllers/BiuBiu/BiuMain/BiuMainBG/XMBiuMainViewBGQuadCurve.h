//
//  XMBiuMainViewBGQuadCurve.h
//  IMeetU
//
//  Created by zhanghao on 16/3/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XMBiuMainViewBGQuadCurve : NSObject

@property (nonatomic, assign) CGFloat cpX;
@property (nonatomic, assign) CGFloat cpY;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

+ (instancetype)quadCurveWithCpX:(CGFloat)cpX xpY:(CGFloat)cpY x:(CGFloat)x y:(CGFloat)y;

+ (instancetype)quadCurveWithOriginX:(CGFloat)ox originY:(CGFloat)oy endX:(CGFloat)ex endY:(CGFloat)ey len:(CGFloat)len;
@end
