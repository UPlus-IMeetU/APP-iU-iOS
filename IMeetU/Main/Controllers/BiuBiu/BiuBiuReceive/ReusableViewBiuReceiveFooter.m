//
//  ReusableViewBiuReceiveFooter.m
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ReusableViewBiuReceiveFooter.h"

@interface ReusableViewBiuReceiveFooter()

@property (weak, nonatomic) IBOutlet UIButton *btnGrabBiu;

@end
@implementation ReusableViewBiuReceiveFooter

- (void)initWithIsGrabbed:(BOOL)isGrabbed{
    self.btnGrabBiu.enabled = isGrabbed;
    [self.btnGrabBiu setTitle:isGrabbed?@"抢biu":@"本次biubiu已结束" forState:UIControlStateNormal];
}
- (IBAction)onClickBtnGrabBiu:(id)sender {
    if (self.delegateFooter) {
        if([self.delegateFooter respondsToSelector:@selector(reusableViewBiuReceiveFooterGrabBiu:WithButton:)]){
            [self.delegateFooter reusableViewBiuReceiveFooterGrabBiu:self WithButton:sender];
        }
    }
}

- (IBAction)onClickBtnUnreceiveTA:(id)sender {
    if (self.delegateFooter) {
        if ([self.delegateFooter respondsToSelector:@selector(reusableViewBiuReceiveFooterUnreceiveTA:)]) {
            [self.delegateFooter reusableViewBiuReceiveFooterUnreceiveTA:self];
        }
    }
}

@end
