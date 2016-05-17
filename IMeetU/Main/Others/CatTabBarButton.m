//
//  CatTabBarButton.m
//  Catweibo
//
//  Created by Justin on 15/4/2.
//  Copyright (c) 2015年 Justin. All rights reserved.
//

//在此设置按钮默认背景图片
#define K_BUTTON_IMAGE @""
//在此设置按钮被点击状态图片
#define K_BUTTON_IMAGE_SEL @"tabItem_background"
//在此设置按钮的默认的文字颜色
#define CatTabBarButtonTitleColor [UIColor whiteColor]
//在此按钮的默认的文字被点击后颜色
#define CatTabBarButtonSelectTitleColor [UIColor whiteColor]

//图片比例
#define CatTabBarButtonRatio 0.6

#import "CatTabBarButton.h"

@implementation CatTabBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置按钮图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        //设置按钮文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self setTitleColor:CatTabBarButtonTitleColor forState:UIControlStateNormal];
        
        [self setTitleColor: CatTabBarButtonSelectTitleColor forState:(UIControlStateSelected)];
        [self setBackgroundImage:[UIImage imageNamed:K_BUTTON_IMAGE]  forState:(UIControlStateNormal)];
        
        [self setBackgroundImage:[UIImage imageNamed:K_BUTTON_IMAGE_SEL]forState:(UIControlStateSelected)];
        
    }
    return self;
}

//重写按钮高亮状态
- (void)setHighlighted:(BOOL)highlighted {
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height *CatTabBarButtonRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleY = contentRect.size.height *CatTabBarButtonRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
    
}

-(void)setItem:(UITabBarItem *)item {
    [self setTitle:item.title forState:(UIControlStateNormal)];
    [self setImage:item.image forState:(UIControlStateNormal)];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    
}

@end
