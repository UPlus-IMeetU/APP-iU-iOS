//
//  NSDate+plug.m
//  MeetU
//
//  Created by zhanghao on 15/8/2.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "NSDate+plug.h"

@implementation NSDate(plug)

+ (long)currentTimeMillisSecond{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    return [dat timeIntervalSince1970];
}

+(long)currentTimeMillis{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    return [dat timeIntervalSince1970]*1000;
}

+ (NSString *)timeMillisFormat:(long)time{
    long long lTime = [[NSNumber numberWithInteger:time] longLongValue]; // 将double转为long long型
    
    NSString *curTime = [NSString stringWithFormat:@"%llu",lTime]; // 输出long long型
    NSDate *time_str =[NSDate dateWithTimeIntervalSince1970:[curTime floatValue]];
    NSDateFormatter *date_format_str =[[NSDateFormatter alloc] init];
    [date_format_str setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date_string =[date_format_str stringFromDate:time_str];
    
    return date_string;
}

+ (NSString *)timeMillisFormatWithDate:(NSDate*)date{
    long millis = [date currentTimeMillisSecond];
    return [NSDate timeMillisFormat:millis];
}

+ (NSString*)timeDateFormatYMD:(NSDate*)time{
    long millis = [time currentTimeMillisSecond];
    return [NSDate timeMillisFormatYMD:millis];
}

+ (NSString *)timeMillisFormatYMD:(long)time{
    NSString *strTime = [self timeMillisFormat:time];
    NSRange range=[strTime rangeOfString:@" "];
    if (range.location + range.length > strTime.length) {
        return @"";
    }
    return [[self timeMillisFormat:time] substringToIndex:range.location];
}

+ (NSString*)timeMillisFormatHMS:(long)time{
    NSString *strTime = [self timeMillisFormat:time];
    NSRange range=[strTime rangeOfString:@" "];
    return [[self timeMillisFormat:time] substringFromIndex:range.location+1];
}

-(long)currentTimeMillisSecond{
    
    long time = [self timeIntervalSince1970];
    return time;
}

- (long)yearNumber{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:self];
    
    return [comps year];
}

- (long)monthNumber{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:self];
    
    return [comps month];
}

- (long)dayNumber{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:self];
    
    return [comps day];
}

- (long)hourNumber{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:self];
    
    return [comps hour];
}

- (long)minuteNumber{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:self];
    
    return [comps minute];
}

- (long)secondNumber{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:self];
    
    return [comps second];
}

@end
