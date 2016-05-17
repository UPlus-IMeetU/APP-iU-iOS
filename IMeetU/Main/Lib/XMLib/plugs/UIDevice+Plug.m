//
//  UIDevice+Plug.m
//  MeetU
//
//  Created by zhanghao on 15/7/31.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UIDevice+Plug.h"

@implementation UIDevice(Plug)

+(BOOL)isVersion7x{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version>=7.0 && version<8.0;
}

+(BOOL)isVersion8x{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version>=8.0 && version<9.0;
}

+(BOOL)isVersion9x{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version>=9.0 && version<10.0;
}

@end
