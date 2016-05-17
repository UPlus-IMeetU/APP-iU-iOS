//
//  MLStructWrap.m
//  MeetU
//
//  Created by zhanghao on 15/8/25.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "MLStructWrap.h"

@implementation MLStructWrap


+ (CGRect)resetRectX:(CGRect)rect newX:(float)x{
    return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

+ (CGRect)floatRectX:(CGRect)rect floatX:(float)x{
    NSLog(@"=================?");
    CGRect newRect = CGRectMake(rect.origin.x + x, rect.origin.y, rect.size.width, rect.size.height);
    NSLog(@"=================?%@", [NSValue valueWithCGRect:newRect]);
    return newRect;
}

/*
CG_INLINE CGRect
FloatRectX(CGRect rect, float x){
    return CGRectMake(rect.origin.x + x, rect.origin.y, rect.size.width, rect.size.height);
}
*/

@end
