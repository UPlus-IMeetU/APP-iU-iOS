//
//  UIImage+Plug.m
//  MettU_iOS
//
//  Created by zhanghao on 15/7/6.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UIImage+Plug.h"

#import "UIColor+Plug.h"

@implementation UIImage(Plug)

+(instancetype)cusImageOfScrWithName:(NSString *)name{
    
    return nil;
}

+(instancetype)cusImageOfSysWithName:(NSString *)name{
    return nil;
}

- (UIImage *)clipEllipseWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a boardWidth:(CGFloat)boardWidth{
    boardWidth = 10;
    CGSize canvasSize = CGSizeMake(self.size.width+boardWidth*2, self.size.height+boardWidth*2);
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect ellipseRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    [[UIColor greenColor] setFill];
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextClip(context);
    CGContextAddRect(context, ellipseRect);
    CGContextDrawPath(context, kCGPathFill);
    
    
    CGRect circleRect = CGRectMake(boardWidth, boardWidth, self.size.width, self.size.height);
    [self drawInRect:circleRect];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (UIImage*)rotateImageToOrientationUp
{
    CGSize size = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
