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
    
    for (int i=0; i<hexStr.length; i++) {
        char num = [hexStr characterAtIndex:i];
        
        //次方数
        int powerNum = 1;
        for(int j=0; j<hexStr.length-i-1; j++){
            powerNum *= 16;
        }
        
        if (num >= '0' && num <= '9') {
            hex += (num-'0')*powerNum;
        }else{
            hex += (num-'A'+10)*powerNum;
        }
    }
    
    return hex;
}

- (NSURL *)url{
    return [NSURL URLWithString:self];
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize constrainedToSize:(CGSize)size{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
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

@end
