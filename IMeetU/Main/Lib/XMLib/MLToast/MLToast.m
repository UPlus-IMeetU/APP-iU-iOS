//
//  MLToast.m
//  MeetU
//
//  Created by zhanghao on 15/11/16.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "MLToast.h"

#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"

@interface MLToast()

@property (nonatomic, strong) UILabel *toastLabelContent;

@property (nonatomic, weak) UIView *inView;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic, assign) CGFloat rightPadding;
@property (nonatomic, assign) CGFloat topPadding;
@property (nonatomic, assign) CGFloat bottomPadding;
@property (nonatomic, assign) CGFloat bottomSpace;


@end
@implementation MLToast

+ (instancetype)toastInView:(UIView*)view content:(NSString*)content{
    MLToast *toast = [[MLToast alloc] init];
    
    toast.inView = view;
    toast.content = content;
    
    [toast initial];
    
    return toast;
}

- (CGFloat)leftPadding{
    return 20;
}

- (CGFloat)rightPadding{
    return 20;
}

- (CGFloat)topPadding{
    return 10;
}

- (CGFloat)bottomPadding{
    return 10;
}

- (CGFloat)bottomSpace{
    return 120;
}

- (void) initial{
    self.toastLabelContent = [[UILabel alloc] init];
    [self.toastLabelContent setText:self.content];
    [self.toastLabelContent setFont:[UIFont systemFontOfSize:12]];
    [self.toastLabelContent setTextColor:[UIColor whiteColor]];
    self.toastLabelContent.numberOfLines = 0;
    self.toastLabelContent.textAlignment = NSTextAlignmentCenter;
    
    CGSize labelSize = [self.toastLabelContent sizeThatFits:CGSizeMake([UIScreen screenWidth]-self.leftPadding-self.rightPadding-150, CGFLOAT_MAX)];
    self.toastLabelContent.frame = CGRectMake(self.leftPadding, self.topPadding, labelSize.width, labelSize.height);
    
    self.frame = CGRectMake(([UIScreen screenWidth]-labelSize.width-self.leftPadding-self.rightPadding)/2, [UIScreen screenHeight]-self.bottomSpace-self.topPadding-self.bottomPadding-labelSize.height, labelSize.width+self.leftPadding+self.rightPadding, labelSize.height+self.topPadding+self.bottomPadding);
    
    self.alpha = 0.8;
    [self addSubview:self.toastLabelContent];
    [self setBackgroundColor:[UIColor colorWithR:0 G:0 B:0 A:0.4]];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)show{
    [self.inView addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:1.5 delay:1 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}
@end
