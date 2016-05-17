//
//  ViewNewComerGuide.m
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewNewComerGuide.h"
#import "UIScreen+Plug.h"
#import "UINib+Plug.h"

@interface ViewNewComerGuide()

@property (weak, nonatomic) IBOutlet UIView *viewGuideFirst;
@property (weak, nonatomic) IBOutlet UIView *viewGuideSecond;
@property (weak, nonatomic) IBOutlet UIView *viewGuideThird;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnBottom;

@end
@implementation ViewNewComerGuide

+ (instancetype)view{
    return [UINib xmViewWithName:@"ViewNewComerGuide" class:[ViewNewComerGuide class]];
}

- (void)layoutSubviews{
    self.constraintBtnBottom.constant = [self btnBottomFirstPag];
}

- (void)showInView:(UIView*)superView completion:(void(^)(BOOL finished))completion{
    self.alpha = 0;
    self.frame = superView.bounds;
    [superView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) {
            completion (finished);
        }
    }];
}

- (IBAction)onClickBtnFirst:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.viewGuideFirst.alpha = 0;
    } completion:^(BOOL finished) {
        self.viewGuideFirst.hidden = YES;
    }];
}

- (IBAction)onClickBtnSecond:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.viewGuideSecond.alpha = 0;
    } completion:^(BOOL finished) {
        self.viewGuideSecond.hidden = YES;
    }];
}

- (IBAction)onClickBtnThird:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (CGFloat)btnBottomFirstPag{
    if ([UIScreen is35Screen]) {
        return 100;
    }
    return 166;
}

@end
