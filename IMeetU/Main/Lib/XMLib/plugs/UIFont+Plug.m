//
//  UIFont+Plug.m
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UIFont+Plug.h"
#import <CoreText/CoreText.h>

@implementation UIFont(Plug)

+ (UIFont *)xmFontWithPath:(NSString *)path size:(CGFloat)size{
    NSString *name = @"";//[self getMLToolsFontTypeWithEnum:MLToolsFontTypeXDXWZ];
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

@end
