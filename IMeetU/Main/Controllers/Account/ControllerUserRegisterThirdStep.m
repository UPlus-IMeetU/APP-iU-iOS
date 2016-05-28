//
//  ControllerRegisterThirdStep.m
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserRegisterThirdStep.h"
#import <YYKit/YYKit.h>
#import <YYKeyboardManager/YYKeyboardManager.h>
#import <AVOSCloud/AVOSCloud.h>

#import "AFNetworking.h"
#import "ControllerUserLogin.h"

#import "ModelRequestRegister.h"

#import "UIStoryboard+Plug.h"

#import "XMUrlHttp.h"

#import "ModelResponse.h"
#import "ModelResponseRegisterLogin.h"

#import "XMOSS.h"
#import "UserDefultAccount.h"

#import "MBProgressHUD+plug.h"
#import "MobClick.h"
#import "UIScreen+Plug.h"
#import "ControllerUserRegisterSecondStep.h"

#import "MLToast.h"
#import "MobClick.h"

@interface ControllerUserRegisterThirdStep ()<YYKeyboardObserver>

@property (nonatomic, strong) ModelRequestRegister *modelRequestRegister;

@property (nonatomic, strong) UIImage *imgProfile;

@property (nonatomic, strong) NSTimer *timerReceiveSms;
@property (nonatomic, assign) NSInteger timeReceiveSmsCount;
@property (weak, nonatomic) IBOutlet UILabel *labelReceiveSms;
@property (weak, nonatomic) IBOutlet UIButton *btnSendSms;

@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (weak, nonatomic) IBOutlet UITextField *textPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textSecurityCode;
@property (weak, nonatomic) IBOutlet UITextField *textPasswd;

@property (weak, nonatomic) IBOutlet UIButton *btnRegisterNext;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeaderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnGoalBottom;

@end

@implementation ControllerUserRegisterThirdStep

+ (instancetype)controller{
    ControllerUserRegisterThirdStep *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameAccount indentity:@"ControllerUserRegisterThirdStep"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraintViewHeaderHeight.constant = [self viewHeaderHeight];
    self.constraintBtnGoalBottom.constant = [self constantConstraintBtnActionBottom];
    
    UITapGestureRecognizer *tapGestureRecognizerViewMain = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.viewMain endEditing:YES];
    }];
    [self.viewMain addGestureRecognizer:tapGestureRecognizerViewMain];
    
    [[YYKeyboardManager defaultManager] addObserver:self];
    
    [self.textPhoneNumber addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        if (self.textPhoneNumber.text.length > 11) {
            [self.textPhoneNumber setText:[self.textPhoneNumber.text substringToIndex:11]];
        }
        [self isEnableToNext];
    }];
    [self.textSecurityCode addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        if (self.textSecurityCode.text.length > 6) {
            [self.textSecurityCode setText:[self.textSecurityCode.text substringToIndex:6]];
        }
        [self isEnableToNext];
    }];
    [self.textPasswd addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        if (self.textPasswd.text.length > 16) {
            [self.textPasswd setText:[self.textPasswd.text substringToIndex:16]];
        }
        [self isEnableToNext];
    }];
    
    [MobClick event:@"register_start"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)onClickBtnSendSms:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"正在发送..." animated:YES];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters = @{@"phone":self.textPhoneNumber.text};
    
    [httpManager POST:[XMUrlHttp xmIsRegisteredPhone] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        if (response.state == 200) {
            NSDictionary *dic = response.data;
            BOOL isRegister = [dic[@"result"] boolValue];
            if (!isRegister) {
                //友盟账号统计:发送短信验证码
                [MobClick event:@"register_sms_send"];
                
                [AVOSCloud requestSmsCodeWithPhoneNumber:self.textPhoneNumber.text appName:@"MeetU" operation:@"注册" timeToLive:10 callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self.labelReceiveSms setText:@"重新获取(60s)"];
                        [self timerReceiveSmsLaunch];
                        self.btnSendSms.enabled = NO;
                        [self.btnSendSms setBackgroundImage:[UIImage imageNamed:@"register_verify_code_btn"] forState:UIControlStateNormal];
                        
                        [hud xmSetCustomModeWithResult:YES label:@"验证码已发送"];
                        [hud hide:YES];
                        
                        //友盟账号统计:发送短信验证码成功
                        [MobClick event:@"register_sms_send_success"];
                    }else{
                        self.btnSendSms.enabled = YES;
                        [self.labelReceiveSms setText:@"获取验证码"];
                        [self.timerReceiveSms invalidate];
                        self.timerReceiveSms = nil;
                        [hud xmSetCustomModeWithResult:NO label:@"验证码发送失败"];
                        [hud hide:YES afterDelay:0.3];
                    }
                }];
            }else{
                self.btnSendSms.enabled = YES;
                [self.labelReceiveSms setText:@"获取验证码"];
                [self.timerReceiveSms invalidate];
                self.timerReceiveSms = nil;
                [hud xmSetCustomModeWithResult:NO label:@"号码已存在,请登录"];
                [hud hide:YES afterDelay:1];
                dispatch_after(2.5*NSEC_PER_SEC, dispatch_get_main_queue(), ^{
                    ControllerUserLogin *controller = [ControllerUserLogin controller];
                    [self.navigationController pushViewController:controller animated:YES];
                });
            }
            
        }else{
            self.btnSendSms.enabled = YES;
            [self.labelReceiveSms setText:@"获取验证码"];
            [self.timerReceiveSms invalidate];
            self.timerReceiveSms = nil;
            [hud xmSetCustomModeWithResult:NO label:@"验证码发送失败"];
            [hud hide:YES afterDelay:0.3];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.btnSendSms.enabled = YES;
        [self.labelReceiveSms setText:@"获取验证码"];
        [self.timerReceiveSms invalidate];
        self.timerReceiveSms = nil;
        [hud xmSetCustomModeWithResult:NO label:@"验证码发送失败"];
        [hud hide:YES afterDelay:0.3];
    }];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onClickBtnNextStep:(id)sender {
    [self.view endEditing:YES];
    
     MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"验证中..." animated:YES];
     
    [AVOSCloud verifySmsCode:self.textSecurityCode.text mobilePhoneNumber:self.textPhoneNumber.text callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [hud xmSetCustomModeWithResult:YES label:@"验证成功"];
            [hud hide:YES afterDelay:0.3];
            
            self.modelRequestRegister.phone = self.textPhoneNumber.text;
            self.modelRequestRegister.password = self.textPasswd.text;
            
            //友盟账号统计:短信验证码验证成功
            [MobClick event:@"register_sms_verify"];
            
            ControllerUserRegisterSecondStep *controller = [ControllerUserRegisterSecondStep controllerWithModel:self.modelRequestRegister profile:self.imgProfile];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"验证码错误"];
            [hud hide:YES afterDelay:0.3];
        }
    }];
    
//    self.modelRequestRegister.phone = self.textPhoneNumber.text;
//    self.modelRequestRegister.password = self.textPasswd.text;
//    ControllerUserRegisterSecondStep *controller = [ControllerUserRegisterSecondStep controllerWithModel:self.modelRequestRegister profile:self.imgProfile];
//    [self.navigationController pushViewController:controller animated:YES];
}


- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition{
    CGFloat constraintConstantHeight;
    if (transition.toVisible) {
        constraintConstantHeight = (transition.toFrame.size.height+20)-[self constantConstraintBtnActionBottom];
    }else{
        constraintConstantHeight = 0;
    }
    
    [UIView animateWithDuration:transition.animationDuration animations:^{
        self.constraintViewMainTop.constant = -constraintConstantHeight;
        self.constraintViewMainBottom.constant = constraintConstantHeight;
        [self.view layoutIfNeeded];
    }];
}

- (void)isEnableToNext{
    if (self.textPhoneNumber.text.length>10 && self.textSecurityCode.text.length>5 && self.textPasswd.text.length>5) {
        self.btnRegisterNext.enabled = YES;
    }else{
        self.btnRegisterNext.enabled = NO;
    }
}

- (void)timerReceiveSmsLaunch{
    if (!self.timerReceiveSms) {
        self.timeReceiveSmsCount = 59;
        
        self.timerReceiveSms = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            if (self.timeReceiveSmsCount<0) {
                [self.labelReceiveSms setText:@"获取验证码"];
                [self.timerReceiveSms invalidate];
                self.timerReceiveSms = nil;
                self.btnSendSms.enabled = YES;
                [self.btnSendSms setBackgroundImage:[UIImage imageNamed:@"register_verify_code_btn_light"] forState:UIControlStateNormal];
            }else{
                [self.labelReceiveSms setText:[NSString stringWithFormat:@"重新获取(%lus)", self.timeReceiveSmsCount]];
            }
            self.timeReceiveSmsCount --;
        } repeats:YES];
    
    }
}

- (ModelRequestRegister *)modelRequestRegister{
    if (!_modelRequestRegister) {
        _modelRequestRegister = [[ModelRequestRegister alloc] init];
    }
    return _modelRequestRegister;
}

- (CGFloat)viewHeaderHeight{
    if ([UIScreen is35Screen]) {
        return 100;
    }
    return 178;
}

- (CGFloat)constantConstraintBtnActionBottom{
    if ([UIScreen is35Screen]) {
        return 40;
    }else if ([UIScreen is40Screen]){
        return 100;
    }else if ([UIScreen is47Screen]){
        return 177;
    }else if ([UIScreen is55Screen]){
        return 200;
    }
    return 0;
}

@end
