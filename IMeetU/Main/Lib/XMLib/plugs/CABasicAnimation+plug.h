//
//  CABasicAnimation+plug.h
//  IMeetU
//
//  Created by zhanghao on 16/3/24.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation(plug)

+ (CABasicAnimation *) animationBlinkWithKeyPath:(NSString*)keyPath duration:(float)duration fromAlpha:(float)fromAlpha toAlpha:(float)toAlpha repeatCount:(NSInteger)repeatCount;

@end
