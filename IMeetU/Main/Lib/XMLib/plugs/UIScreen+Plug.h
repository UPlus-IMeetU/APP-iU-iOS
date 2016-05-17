//
//  UIScreen+Plug.h
//  MettU_iOS
//
//  Created by zhanghao on 15/7/8.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScreenSize) {
    ScreenSize00,
    ScreenSize35,
    ScreenSize40,
    ScreenSize47,
    ScreenSize55
};

@interface UIScreen(Plug)

/**
 *  获得当前屏幕尺寸枚举
 *
 *  @return 屏幕尺寸
 */
+ (ScreenSize)screenSizeIsInch;

#pragma mark - 判断当前设备屏幕是否为指定尺寸
+(BOOL)is35Screen;

+(BOOL)is40Screen;

+(BOOL)is47Screen;

+(BOOL)is55Screen;

#pragma mark - 获得对应尺寸屏幕的分辨率
+ (CGFloat)screenWidth40;

+ (CGFloat)screenWidth47;

+ (CGFloat)screenWidth55;

#pragma mark - 获得当前设备屏幕长宽

+ (float)screenWidth;

+ (float)screenHeight;

+ (float)screenScale;

@end
