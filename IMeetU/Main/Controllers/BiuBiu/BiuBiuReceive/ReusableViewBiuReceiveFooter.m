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

//- (void)initWithIsGrabbed:(NSString *)isGrabbed{
//    self.btnGrabBiu.enabled = isGrabbed;
//    [self.btnGrabBiu setTitle:isGrabbed?@"抢biu":@"本轮biubiu已结束" forState:UIControlStateNormal];
//}

- (void)initWithMessage:(NSInteger)message{
    if (message == 0) {
        self.btnGrabBiu.enabled = NO;
        [self.btnGrabBiu setTitle:@"本轮biubiu已结束" forState:UIControlStateNormal];
    }else if(message == 1){
        self.btnGrabBiu.enabled = YES;
        [self.btnGrabBiu setTitle:@"收Biu" forState:UIControlStateNormal];
    }else if(message == 2){
        self.btnGrabBiu.enabled = YES ;
        [self.btnGrabBiu setTitle:@"再次抢biu" forState:UIControlStateNormal];
    }else if (message == 3){
        self.btnGrabBiu.enabled = NO;
        [self.btnGrabBiu setTitle:@"已接受" forState:UIControlStateNormal];
    }
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
