//
//  XMBiuMainViewBGQuadCurve.m
//  IMeetU
//
//  Created by zhanghao on 16/3/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMBiuMainViewBGQuadCurve.h"

@implementation XMBiuMainViewBGQuadCurve

+ (instancetype)quadCurveWithCpX:(CGFloat)cpX xpY:(CGFloat)cpY x:(CGFloat)x y:(CGFloat)y{
    XMBiuMainViewBGQuadCurve *quadCurve = [[XMBiuMainViewBGQuadCurve alloc] init];
    quadCurve.cpX = cpX;
    quadCurve.cpY = cpY;
    quadCurve.x = x;
    quadCurve.y = y;
    
    return quadCurve;
}

+ (instancetype)quadCurveWithOriginX:(CGFloat)ox originY:(CGFloat)oy endX:(CGFloat)ex endY:(CGFloat)ey len:(CGFloat)len{
    //求线的斜率
    CGFloat k = (ey-oy)/(ex-ox);
    //求此线中垂线的斜率
    CGFloat km = -1/k;
    
    //求连线交点坐标
    CGFloat x = (ox+ex)/2;
    CGFloat y = (oy+ey)/2;
    
    //求控制点坐标
    CGFloat cpx = x+cos(km)*len;
    CGFloat cpy = y+sin(km)*len;
    
    NSLog(@"->%f->%f->%f->%f->%f->%f->%f", ox, oy, cpx, cpy, km, ex, ey);
    
    XMBiuMainViewBGQuadCurve *quadCurve = [[XMBiuMainViewBGQuadCurve alloc] init];
    quadCurve.cpX = cpx;
    quadCurve.cpY = cpy;
    quadCurve.x = ex;
    quadCurve.y = ey;
    
    return quadCurve;

}

@end
