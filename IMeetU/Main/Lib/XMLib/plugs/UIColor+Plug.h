//
//  UIColor+Plug.h
//  MeetU
//
//  Created by zhanghao on 15/8/17.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Plug)

/**
 * 没有透明RGB颜色 RRGGBB
 */
+ (instancetype)xmColorWithHexStrRGB:(NSString*)colorStr;
/**
 * 有透明RGBA颜色 RRGGBBAA
 */
+ (instancetype)xmColorWithHexStrRGBA:(NSString*)colorStr;
/**
 * 有透明RGB颜色 RRGGBB，alpha为透明度（0~1.0）
 */
+ (instancetype)xmColorWithHexStrRGB:(NSString*)colorStr alpha:(CGFloat)alpha;

#pragma mark - 常用颜色
+ (instancetype)often_000000:(float)alpha;

+ (instancetype)often_007AFF:(float)alpha;

+ (instancetype)often_606366:(float)alpha;

+ (instancetype)often_33C6E5:(float)alpha;

+ (instancetype)often_A0A0A0:(float)alpha;

+ (instancetype)often_AAAAAA:(float)alpha;

+ (instancetype)often_BFBFBF:(float)alpha;

+ (instancetype)often_6CD1C9:(float)alpha;

+ (instancetype)often_CCCCCC:(float)alpha;

+ (instancetype)often_EEEEEE:(float)alpha;

+ (instancetype)often_FF5CFF:(float)alpha;

+ (instancetype)often_FFFFFF:(float)alpha;

+ (instancetype)often_808080:(float)alpha;

+ (instancetype)often_8883BC:(float)alpha;

+ (instancetype)often_F06E7F:(float)alpha;

+ (instancetype)often_FCFCC8:(float)alpha;

+ (instancetype)often_999999:(float)alpha;

+ (UIColor *)oftenOrange;
+ (UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

+ (UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;

#pragma mark - 在色库内获取一个随机色
+ (UIColor*)getRandomColor;

/**
 *  获取UIColor的rgba色值
 *
 *  @return 包含rgba的字典
 */
- (NSDictionary*)currentRGBA;
@end
