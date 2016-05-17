//
//  UIView+Plug.m
//  MeetU_iOS
//
//  Created by zhanghao on 15/7/20.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UIView+Plug.h"

@implementation UIView(Plug)

-(void)changeWithX:(float)x y:(float)y width:(float)width height:(float)height{
    self.frame = CGRectMake(self.frame.origin.x + x, self.frame.origin.y + y, self.frame.size.width + width, self.frame.size.height + height);
}

- (void)clipCorner:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)clipCorner:(CGFloat)cornerRadius viewSize:(CGSize)size byRoundingCorners:(UIRectCorner)corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = CGRectMake(0, 0, size.width, size.height);
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addCliclkListenerToSelf{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickSelfWithTapGestureRecognizer:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)onClickSelfWithTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{

}

@end
