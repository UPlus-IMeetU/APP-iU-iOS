//
//  NSDate+plug.h
//  MeetU
//
//  Created by zhanghao on 15/8/2.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(plug)

/**
 *  获取秒
 *
 *  @return <#return value description#>
 */
+ (long)currentTimeMillisSecond;


/**
 *  获取毫秒
 *
 *  @return <#return value description#>
 */
+(long)currentTimeMillis;

+ (NSString*)timeMillisFormat:(long)time;

+ (NSString *)timeMillisFormatWithDate:(NSDate*)date;

+ (NSString*)timeMillisFormatYMD:(long)time;

+ (NSString*)timeDateFormatYMD:(NSDate*)time;

+ (NSString*)timeMillisFormatHMS:(long)time;

-(long)currentTimeMillisSecond;

- (long)yearNumber;
- (long)monthNumber;
- (long)dayNumber;

- (long)hourNumber;
- (long)minuteNumber;
- (long)secondNumber;


//=========================================================================================
- (BOOL)xmIsToday;

- (BOOL)xmIsYesterday;

- (NSString *)xmShortTimeTextOfDate;

- (NSString *)xmTimeTextOfDate;

@end
