//
//  ReusableViewMatchSettingFooter.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ReusableViewMatchSettingFooter.h"
#import "UserDefultAccount.h"
#import "ModelMatchSetting.h"

@interface ReusableViewMatchSettingFooter()<UIAlertViewDelegate>

@property (nonatomic, strong) ModelMatchSetting *model;
@property (weak, nonatomic) IBOutlet UISwitch *switchNewMsg;
@property (weak, nonatomic) IBOutlet UISwitch *switchMsgSound;
@property (weak, nonatomic) IBOutlet UISwitch *switchMsgVibration;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;


@end
@implementation ReusableViewMatchSettingFooter

- (void)initWithModel:(ModelMatchSetting *)model{
    self.model = model;
    
    self.switchNewMsg.on = model.pushNewMsg;
    self.switchMsgSound.on = model.pushSound;
    self.switchMsgVibration.on = model.pushVibration;
}

- (IBAction)onChangeSwitchNewMsg:(UISwitch*)sender {
    if (!sender.on) {
        self.switchMsgSound.on = NO;
        self.switchMsgVibration.on = NO;
    }
    [self onChangeSwitch];
}

- (IBAction)onChangeSwitchMsgSound:(UISwitch*)sender {
    if (sender.on) {
        self.switchNewMsg.on = YES;
    }
    [self onChangeSwitch];
}

- (IBAction)onChangeSwitchMsgVibration:(UISwitch*)sender {
    if (sender.on) {
        self.switchNewMsg.on = YES;
    }
    [self onChangeSwitch];
}

- (IBAction)onClickBtnLogout:(UIButton*)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出当前账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.delegateMatchSetting) {
            if ([self.delegateMatchSetting respondsToSelector:@selector(reusableViewMatchSettingFooter:switchRes:)]) {
                [self.delegateMatchSetting reusableViewMatchSettingFooter:self onLogout:self.btnLogout];
            }
        }
    }
}
- (void)onChangeSwitch{
    if (self.delegateMatchSetting) {
        if ([self.delegateMatchSetting respondsToSelector:@selector(reusableViewMatchSettingFooter:switchRes:)]) {
            ModelMatchSetting *model = [[ModelMatchSetting alloc] init];
            model.pushNewMsg = self.switchNewMsg.on;
            model.pushSound = self.switchMsgSound.on;
            model.pushVibration = self.switchMsgVibration.on;
            [self.delegateMatchSetting reusableViewMatchSettingFooter:self switchRes:model];
        }
    }
}

- (IBAction)setBtnClick:(id)sender {
    if (self.delegateMatchSetting) {
        if([self.delegateMatchSetting respondsToSelector:@selector(reusableViewMatchSettingFooter:setBtnClick:)]){
            [self.delegateMatchSetting reusableViewMatchSettingFooter:self setBtnClick:sender];
        }
    }
}


@end
