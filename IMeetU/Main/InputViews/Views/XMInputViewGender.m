//
//  TFInputViewGender.m
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMInputViewGender.h"

@interface XMInputViewGender()
@property (weak, nonatomic) IBOutlet UIButton *btnBoy;
@property (weak, nonatomic) IBOutlet UIButton *btnGirl;

//status=0未选中，=1男生，=2女生
@property (nonatomic, assign) NSInteger status;
@end
@implementation XMInputViewGender

- (IBAction)onClickBtnBoy:(id)sender {
    self.status = 1;
    [self setStatus:self.status];
    
    if (self.delegateXMInputView != nil) {
        if ([self.delegateXMInputView respondsToSelector:@selector(xmInputViewGenderInputWithGenderStr:genderNum:)]) {
            [self.delegateXMInputView xmInputViewGenderInputWithGenderStr:@"男生" genderNum:1];
        }
    }
}

- (IBAction)onClickBtnGirl:(id)sender {
    self.status = 2;
    [self setStatus:self.status];

    if (self.delegateXMInputView != nil) {
        if ([self.delegateXMInputView respondsToSelector:@selector(xmInputViewGenderInputWithGenderStr:genderNum:)]) {
            [self.delegateXMInputView xmInputViewGenderInputWithGenderStr:@"女生" genderNum:2];
        }
    }
}

- (void)layoutSubviews{
    if (self.datasourceXMInputView) {
        if ([self.datasourceXMInputView respondsToSelector:@selector(initGenterInXmInputViewGender:)]) {
            self.status = [self.datasourceXMInputView initGenterInXmInputViewGender:self];;
        }
    }
}

- (void)setStatus:(NSInteger)status{
    switch (status) {
        case 1:
            [self.btnBoy setSelected:YES];
            [self.btnGirl setSelected:NO];
            break;
        case 2:
            [self.btnBoy setSelected:NO];
            [self.btnGirl setSelected:YES];
            break;
        default:
            [self.btnBoy setSelected:NO];
            [self.btnGirl setSelected:NO];
            break;
    }
}
@end
