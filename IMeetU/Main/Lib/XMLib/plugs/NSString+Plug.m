//
//  NSString+Plug.m
//  MeetU
//
//  Created by zhanghao on 15/8/15.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "NSString+Plug.h"

@implementation NSString(Plug)

+ (NSInteger)hexNumberWithString:(NSString *)string{
    NSInteger hex = 0;
    NSString *hexStr = [string uppercaseString];
    
    int power = 0;
    for (int i = (int)string.length-1; i>=0; i--){
        char now = [hexStr characterAtIndex:i];
        int num = 0;
        if (now >= '0' && now <= '9') {
            num = now - '0';
        }else if (now >= 'A' && now <= 'F'){
            num = now - 'A' + 10;
        }else{
            return 0;
        }
        
        int k = 1;
        for (int j=0; j<power; j++) {
            k *= 16;
        }
        
        hex += num*k;
        
        power ++;
    }
    
    return hex;
}

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSURL *)url{
    return [NSURL URLWithString:self];
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize constrainedToSize:(CGSize)size{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }else{
        //获取当前文本的属性
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self];
        //_text.attributedText = attrStr;
        NSRange range = NSMakeRange(0, attrStr.length);
        // 获取该段attributedString的属性字典
        NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
        // 计算文本的大小
        return [self boundingRectWithSize:size       // 用于计算文本绘制时占据的矩形块
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                               attributes:dic        // 文字的属性
                                  context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    }
    
    return CGSizeZero;
}

+ (instancetype)xmStringWithInt:(int)num{
    return [NSString stringWithFormat:@"%i", num];
}
+ (instancetype)xmStringWithDouble:(double)num{
    return [NSString stringWithFormat:@"%f", num];
}
+ (instancetype)xmStringWithFloat:(float)num{
    return [NSString stringWithFormat:@"%f", num];
}
+ (instancetype)xmStringWithLong:(long)num{
    return [NSString stringWithFormat:@"%li", num];
}
+ (instancetype)xmStringWithLongLong:(long long)num{
    return [NSString stringWithFormat:@"%lli", num];
}

@end
