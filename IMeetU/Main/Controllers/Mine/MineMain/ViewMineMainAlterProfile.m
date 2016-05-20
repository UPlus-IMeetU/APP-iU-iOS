//
//  ViewMineMainAlterProfile.m
//  IMeetU
//
//  Created by zhanghao on 16/3/10.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewMineMainAlterProfile.h"
#import <YYKit/YYKit.h>
#import "UIScreen+Plug.h"
#import "UINib+Plug.h"

#import "XMAlertDialogRealProfile.h"

@interface ViewMineMainAlterProfile()<XMAlertDialogRealProfileDelegate>

@property (nonatomic, assign) BOOL isMine;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *viewIndicatorLoading;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnAlterProfile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImgViewProfileHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImgViewProfileWidth;

@property (nonatomic, strong) XMAlertDialogRealProfile *alterDialog;
@end
@implementation ViewMineMainAlterProfile

+ (instancetype)viewMineMainAlterProfileWithIsMine:(BOOL)isMine{
    ViewMineMainAlterProfile *view = [UINib xmViewWithName:@"ViewMineMainAlterProfile" class:[ViewMineMainAlterProfile class]];
    view.isMine = isMine;
    [view initial];
    
    return view;
}

- (void)initial{
    self.alpha = 0;
    self.frame = CGRectMake(0, 0, [UIScreen screenWidth], [UIScreen screenHeight]);
    self.constraintImgViewProfileHeight.constant = 0;
    self.constraintImgViewProfileWidth.constant = 0;
    [self.viewIndicatorLoading startAnimating];
    self.btnAlterProfile.alpha = 0;
    
    UITapGestureRecognizer *tapGestureRecognizerView = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        if (self.delegateProfile) {
            if ([self.delegateProfile respondsToSelector:@selector(viewMineMainAlterProfileClose:)]) {
                [self.delegateProfile viewMineMainAlterProfileClose:self];
            }
        }
    }];
    [self addGestureRecognizer:tapGestureRecognizerView];
    
    self.btnAlterProfile.hidden = !self.isMine;
}

- (void)showWithUrl:(NSString *)url superView:(UIView *)superView{
    [superView addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
    
    [self.imgViewProfile setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionRefreshImageCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            [UIView animateWithDuration:0.3 animations:^{
                self.constraintImgViewProfileHeight.constant = [UIScreen screenWidth];
                self.constraintImgViewProfileWidth.constant = [UIScreen screenWidth];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.btnAlterProfile.alpha = 1;
            }];
        }
    }];
}

- (IBAction)onClickBtnPrepareAlterProfile:(id)sender {
    self.alterDialog = [XMAlertDialogRealProfile alertDialog];
    self.alterDialog.delegateAlertDialog = self;
    [self.alterDialog showWithSuperView:self];
}

- (void)xmAlertDialogRealProfileOnClick:(XMAlertDialogRealProfile *)alertDialog{
    if (self.delegateProfile) {
        if ([self.delegateProfile respondsToSelector:@selector(viewMineMainAlterProfileAfterReadingDialog:)]) {
            [self.delegateProfile viewMineMainAlterProfileAfterReadingDialog:self];
        }
    }
}

- (void)hiddenAndRemove{
    [self.alterDialog hiddenAndRemove];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
