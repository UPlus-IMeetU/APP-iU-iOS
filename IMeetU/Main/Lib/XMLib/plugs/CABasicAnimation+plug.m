//
//  CABasicAnimation+plug.m
//  IMeetU
//
//  Created by zhanghao on 16/3/24.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CABasicAnimation+plug.h"

@implementation CABasicAnimation(plug)

+ (CABasicAnimation *) animationBlinkWithKeyPath:(NSString*)keyPath duration:(float)duration fromAlpha:(float)fromAlpha toAlpha:(float)toAlpha repeatCount:(NSInteger)repeatCount {
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = [NSNumber numberWithFloat:fromAlpha];
    animation.toValue = [NSNumber numberWithFloat:toAlpha];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

@end
