//
//  UIImage+Plug.h
//  MettU_iOS
//
//  Created by zhanghao on 15/7/6.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Plug)

+(instancetype)cusImageOfScrWithName:(NSString*)name;

+(instancetype)cusImageOfSysWithName:(NSString*)name;

- (UIImage *)clipEllipseWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a boardWidth:(CGFloat)boardWidth;

- (UIImage*)rotateImageToOrientationUp;
@end
