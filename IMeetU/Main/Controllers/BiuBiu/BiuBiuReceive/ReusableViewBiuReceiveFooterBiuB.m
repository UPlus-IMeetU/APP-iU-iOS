//
//  ReusableViewBiuReceiveFooterBiuB.m
//  IMeetU
//
//  Created by zhanghao on 16/3/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ReusableViewBiuReceiveFooterBiuB.h"


@interface ReusableViewBiuReceiveFooterBiuB()

@end
@implementation ReusableViewBiuReceiveFooterBiuB

- (IBAction)onClickBtnPay:(id)sender {
    if (self.delegateFooter) {
        if ([self.delegateFooter respondsToSelector:@selector(reusableViewBiuReceiveFooterBiuBPay:)]) {
            [self.delegateFooter reusableViewBiuReceiveFooterBiuBPay:self];
        }
    }
}

- (IBAction)onClickBtnSendBiu:(id)sender {
    if (self.delegateFooter) {
        if ([self.delegateFooter respondsToSelector:@selector(reusableViewBiuReceiveFooterBiuBSend:)]) {
            [self.delegateFooter reusableViewBiuReceiveFooterBiuBSend:self];
        }
    }
}

@end
