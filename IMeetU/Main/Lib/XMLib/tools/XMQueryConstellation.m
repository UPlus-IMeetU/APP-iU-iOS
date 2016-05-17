//
//  MLQueryConstellation.m
//  MeetU
//
//  Created by zhanghao on 15/8/13.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMQueryConstellation.h"
#import "NSDate+plug.h"

@implementation XMQueryConstellation

+(NSString *)constellationWithDate:(NSInteger)date{
    NSDate *nsdate = [NSDate dateWithTimeIntervalSince1970:date];
    NSInteger month = [nsdate monthNumber];
    NSInteger day = [nsdate dayNumber];
    
    NSArray *constellation = [self constellations];
    long startMonth[] = {1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12};
    long startDay[] =   {20, 19, 21, 20, 21, 22, 23, 23, 23, 24, 23, 22};
    long endMonth[] =   {2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 12, 1};
    long endDay[] =     {18, 20, 19, 20, 21, 22, 22, 22, 23, 22, 21, 31, 19};
    
    //循环寻找日期连续的前11个星座
    for (int i=0; i<11; i++) {
        if (month >= startMonth[i] && month <= endMonth[i]) {
            if (day >= startDay[i] || day <= endDay[i]) {
                return constellation[i];
            }
        }
    }
    
    //如果之前不能找到，那只能是魔蝎座
    return @"摩羯座";
}

+ (NSArray *)constellations{
    return @[
             @"水瓶座",@"双鱼座",@"白羊座",@"金牛座",
             @"双子座",@"巨蟹座",@"狮子座",@"处女座",
             @"天秤座",@"天蝎座",@"射手座",@"摩羯座"
             ];
}

@end
