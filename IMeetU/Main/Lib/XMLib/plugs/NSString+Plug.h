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

@end
