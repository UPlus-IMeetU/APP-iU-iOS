//
//  UIScreen+Plug.m
//  MettU_iOS
//
//  Created by zhanghao on 15/7/8.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UIScreen+Plug.h"

@implementation UIScreen(Plug)

+ (ScreenSize)screenSizeIsInch{
    if (480 == [UIScreen mainScreen].bounds.size.height) {
        return ScreenSize35;
    }else if (568 == [UIScreen mainScreen].bounds.size.height) {
        return ScreenSize40;
    }else if (667 == [UIScreen mainScreen].bounds.size.height){
        return ScreenSize47;
    }else if (736 == [UIScreen mainScreen].bounds.size.height){
        return ScreenSize55;
    }
    
    return ScreenSize00;
}

-(void)setScreenSize:(ScreenSize)screenSize{}

+ (BOOL)is35Screen{
    return 480 == [UIScreen mainScreen].bounds.size.height;
}

+(BOOL)is40Screen{
    return 568 == [UIScreen mainScreen].bounds.size.height;
}

+(BOOL)is47Screen{
    return 667 == [UIScreen mainScreen].bounds.size.height;
}

+(BOOL)is55Screen{
    return 736 == [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)screenWidth40{
    return 320;
}

+ (CGFloat)screenWidth47{
    return 375;
}

+ (CGFloat)screenWidth55{
    return 414;
}

+(float)screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

+(float)screenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (float)screenScale{
    return [UIScreen mainScreen].scale;
}

@end
