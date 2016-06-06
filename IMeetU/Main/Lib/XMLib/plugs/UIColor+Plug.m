//
//  UIColor+Plug.m
//  MeetU
//
//  Created by zhanghao on 15/8/17.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UIColor+Plug.h"
#import "NSString+Plug.h"

@implementation UIColor(Plug)

+ (instancetype)xmColorWithHexStrRGB:(NSString *)colorStr{
    UIColor *color;
    
    if (colorStr.length == 6) {
        
        NSInteger r = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(0, 2)]];
        NSInteger g = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(2, 2)]];
        NSInteger b = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(4, 2)]];
        
        color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    }else{
        color = [UIColor redColor];
    }
    
    return color;
}

+ (instancetype)xmColorWithHexStrRGBA:(NSString *)colorStr{
    UIColor *color;
    
    if (colorStr.length == 8) {
        
        NSInteger r = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(0, 2)]];
        NSInteger g = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(2, 2)]];
        NSInteger b = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(4, 2)]];
        NSInteger a = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(6, 2)]];
        
        color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
    }else{
        color = [UIColor redColor];
    }
    
    return color;
}

+ (instancetype)xmColorWithHexStrRGB:(NSString*)colorStr alpha:(CGFloat)alpha{
    UIColor *color;
    
    if (colorStr.length == 6) {
        //透明度小于0
        alpha = alpha<0?0:alpha;
        //透明度大于1
        alpha = alpha>1?1:alpha;
        
        NSInteger r = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(0, 2)]];
        NSInteger g = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(2, 2)]];
        NSInteger b = [NSString hexNumberWithString:[colorStr substringWithRange:NSMakeRange(4, 2)]];
        
        color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    }else{
        color = [UIColor redColor];
    }
    
    return color;
}

+ (instancetype)often_000000:(float)alpha{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
}

+ (instancetype)often_007AFF:(float)alpha{
    return [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:alpha];
}

+ (instancetype)often_FFFFFF:(float)alpha{
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
}

+ (instancetype)often_33C6E5:(float)alpha{
    return [UIColor colorWithRed:51/255.0 green:198/255.0 blue:229/255.0 alpha:alpha];
}


+ (instancetype)often_808080:(float)alpha{
    return [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:alpha];
}

+ (instancetype)often_606366:(float)alpha{
    return [UIColor colorWithR:96 G:99 B:102 A:alpha];
}

+ (instancetype)often_A0A0A0:(float)alpha{
    return [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:alpha];
}

+ (instancetype)often_AAAAAA:(float)alpha{
    return [UIColor colorWithR:170 G:170 B:170 A:alpha];
}

+ (instancetype)often_BFBFBF:(float)alpha{
    return [UIColor colorWithR:191 G:191 B:191 A:alpha];
}

+ (instancetype)often_6CD1C9:(float)alpha{
    return [UIColor colorWithR:108 G:209 B:201 A:alpha];
}

+ (instancetype)often_CCCCCC:(float)alpha{
    return [UIColor colorWithR:191 G:191 B:191 A:alpha];
}

+ (instancetype)often_EEEEEE:(float)alpha{
    return [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:alpha];
}

+ (instancetype)often_999999:(float)alpha{
    return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:alpha];
}

+ (instancetype)often_8883BC:(float)alpha{
    return [UIColor colorWithRed:136/255.0 green:131/255.0 blue:188/255.0 alpha:alpha];
}

+ (instancetype)often_F06E7F:(float)alpha{
    return [UIColor colorWithRed:240/255.0 green:110/255.0 blue:127/255.0 alpha:alpha];
}

+ (instancetype)often_FF5CFF:(float)alpha{
    return [UIColor colorWithRed:1.0 green:92/255.0 blue:1.0 alpha:alpha];
}

+ (instancetype)often_FCFCC8:(float)alpha{
    return [UIColor colorWithRed:252/255.0 green:252/255.0 blue:200/255.0 alpha:alpha];
}

- (void)setRandomColors:(NSArray *)randomColors{
}

+ (UIColor *)oftenOrange{
    return [UIColor colorWithR:253 G:148 B:38 A:1];
}

+ (UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b{
    return [UIColor colorWithR:r G:g B:b A:1];
}

+ (NSArray *)randomColors{
    return @[
             [UIColor colorWithR:157 G:217 B:221],
             [UIColor colorWithR:158 G:219 B:215],
             [UIColor colorWithR:152 G:202 B:213],
             [UIColor colorWithR:124 G:202 B:206],
             [UIColor colorWithR:155 G:196 B:200],
             [UIColor colorWithR:145 G:196 B:187],
             [UIColor colorWithR:146 G:169 B:199],
             [UIColor colorWithR:99 G:187 B:206],
             [UIColor colorWithR:69 G:173 B:188],
             [UIColor colorWithR:117 G:183 B:173],
             [UIColor colorWithR:75 G:203 B:194],
             [UIColor colorWithR:91 G:200 B:201]
             ];
}

+ (UIColor*)getRandomColor{
    int random = arc4random()%12;
    return [UIColor randomColors][random];
}

- (NSDictionary*)currentRGBA{
    NSMutableDictionary *rgba = [NSMutableDictionary dictionary];
    
    CGColorRef color = [self CGColor];
    int numComponents = (int)CGColorGetNumberOfComponents(color);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        [rgba setObject:[NSNumber numberWithFloat:components[0]] forKey:@"r"];
        [rgba setObject:[NSNumber numberWithFloat:components[1]] forKey:@"g"];
        [rgba setObject:[NSNumber numberWithFloat:components[2]] forKey:@"b"];
        [rgba setObject:[NSNumber numberWithFloat:components[3]] forKey:@"a"];
    }
    
    return rgba;
}

@end
