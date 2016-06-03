//
//  NSString+Plug.h
//  MeetU
//
//  Created by zhanghao on 15/8/15.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(Plug)

+ (NSInteger)hexNumberWithString:(NSString *)string;

- (NSURL*)url;

- (CGSize)sizeWithFontSize:(CGFloat)fontSize constrainedToSize:(CGSize)size;

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)stringByTrim;

+ (instancetype)xmStringWithInt:(int)num;
+ (instancetype)xmStringWithDouble:(double)num;
+ (instancetype)xmStringWithFloat:(float)num;
+ (instancetype)xmStringWithLong:(long)num;
+ (instancetype)xmStringWithLongLong:(long long)num;

@end
