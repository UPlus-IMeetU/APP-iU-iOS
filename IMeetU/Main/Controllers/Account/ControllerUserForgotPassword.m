//
//  ControllerForgotPassword.m
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserForgotPassword.h"
#import <YYKit/YYKit.h>
#import <YYKeyboardManager/YYKeyboardManager.h>
#import "AFNetWorking.h"
#import "ModelResponse.h"
#import "XMUrlHttp.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MLToast.h"
#import "ModelResponseRegisterLogin.h"
#import "UserDefultAccount.h"
#import "UIScreen+Plug.h"
#import "MBProgressHUD+plug.h"

@interface ControllerUserForgotPassword ()<YYKeyboardObserver>

@property (weak, nonatomic) IBOutlet UITextField *textFiledPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldVerificationCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswd;
@property (weak, nonatomic) IBOutlet YYLabel *yyLabelUserProtocol;
@property (weak, nonatomic) IBOutlet UIButton *btnFinishResetPasswd;
@property (weak, nonatomic) IBOutlet UILabel *labelReceiveSms;
@property (weak, nonatomic) IBOutlet UIButton *btnSendSms;
@property (nonatomic, strong) NSTimer *timerReceiveSms;
@property (nonatomic, assign) NSInteger timeReceiveSmsCount;

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeaderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnGoalBottom;
@end

@implementation ControllerUserForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraintViewHeaderHeight.constant = [self viewHeaderHeight];
    self.constraintBtnGoalBottom.constant = [self constantConstraintBtnActionBottom];
    
    [[YYKeyboardManager defaultManager] addObserver:self];
    
    UITapGestureRecognizer *tapGestureRecognizerViewMain = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.viewMain endEditing:YES];
    }];
    [self.viewMain addGestureRecognizer:tapGestureRecognizerViewMain];
    
    [self.textFiledPhone addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        [self isEnableNext];
        if (self.textFiledPhone.text.length > 11) {
            [self.textFiledPhone setText:[self.textFiledPhone.text substringToIndex:11]];
        }
    }];
    [self.textFieldVerificationCode addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        [self isEnableNext];
        if (self.textFieldVerificationCode.text.length > 6) {
            [self.textFieldVerificationCode setText:[self.textFieldVerificationCode.text substringToIndex:6]];
        }
    }];
    [self.textFieldPasswd addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        [self isEnableNext];
        if (self.textFieldPasswd.text.length > 16) {
            [self.textFieldPasswd setText:[self.textFieldPasswd.text substringToIndex:16]];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)onClickBtnGetVerificationCode:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"正在发送..." animated:YES];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters = @{@"phone":self.textFiledPhone.text};
    [httpManager POST:[XMUrlHttp xmIsRegisteredPhone] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        if (response.state == 200) {
            NSDictionary *dic = response.data;
            NSInteger isRegister = [dic[@"result"] integerValue];
            if (isRegister) {
                [AVOSCloud requestSmsCodeWithPhoneNumber:self.textFiledPhone.text appName:@"MeetU" operation:@"注册" timeToLive:10 callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self.labelReceiveSms setText:@"重新获取(60s)"];
                        [self timerReceiveSmsLaunch];
                        self.btnSendSms.enabled = NO;
                        [hud xmSetCustomModeWithResult:YES label:@"已获取验证码"];
                        [hud hide:YES afterDelay:2];
                    }else{
                        [self.timerReceiveSms invalidate];
                        [self.labelReceiveSms setText:@"获取验证码"];
                        self.btnSendSms.enabled = YES;
                        [self.timerReceiveSms invalidate];
                        self.timerReceiveSms = nil;
                        [hud xmSetCustomModeWithResult:NO label:@"获取验证码失败"];
                        [hud hide:YES afterDelay:2];
                    }
                }];
            }else{
                [self.labelReceiveSms setText:@"获取验证码"];
                self.btnSendSms.enabled = YES;
                
                [self.timerReceiveSms invalidate];
                self.timerReceiveSms = nil;
                [hud xmSetCustomModeWithResult:NO label:@"此号码不存在"];
                [hud hide:YES afterDelay:2];
            }
            
        }else{
            [self.labelReceiveSms setText:@"获取验证码"];
            self.btnSendSms.enabled = YES;
            [self.timerReceiveSms invalidate];
            self.timerReceiveSms = nil;
            [hud xmSetCustomModeWithResult:NO label:@"验证号码存在错误"];
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.labelReceiveSms setText:@"获取验证码"];
        self.btnSendSms.enabled = YES;
        
        [self.timerReceiveSms invalidate];
        self.timerReceiveSms = nil;
        [hud xmSetCustomModeWithResult:NO label:@"验证号码存在错误"];
        [hud hide:YES afterDelay:2];
    }];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnFinish:(id)sender {
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"修改中..." animated:YES];
    [AVOSCloud verifySmsCode:self.textFieldVerificationCode.text mobilePhoneNumber:self.textFiledPhone.text callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
            httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            NSDictionary *parameters = @{@"phone":self.textFiledPhone.text, @"password":self.textFieldPasswd.text};
            [httpManager POST:[XMUrlHttp xmResetPassword] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                
                if (response.state == 200) {
                    
                    NSDictionary *parameters = @{@"phone":self.textFiledPhone.text, @"password":self.textFieldPasswd.text, @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
                    [httpManager POST:[XMUrlHttp xmLogin] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                        if (response.state == 200) {
                            ModelResponseRegisterLogin *responseData = [ModelResponseRegisterLogin modelWithJSON:response.data];
                            [UserDefultAccount updateToken:responseData.token];
                            [UserDefultAccount setImName:responseData.imName];
                            [UserDefultAccount setImPasswork:responseData.imPasswork];
                            [UserDefultAccount setGender:responseData.sex];
                            [UserDefultAccount setUserName:responseData.userName];
                            [UserDefultAccount setUserCode:responseData.userCode];
                            [UserDefultAccount setUserProfileUrlThumbnail:responseData.userProfileUrl];
                            
                            [hud xmSetCustomModeWithResult:YES label:@"修改成功..."];
                            [hud hide:YES];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else{
                            [hud xmSetCustomModeWithResult:NO label:@"自动登录失败"];
                            [hud hide:YES afterDelay:2];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [hud xmSetCustomModeWithResult:NO label:@"自动登录失败"];
                        [hud hide:YES afterDelay:2];
                    }];
                    
                }else{
                    [hud xmSetCustomModeWithResult:NO label:@"重置密码失败"];
                    [hud hide:YES afterDelay:2];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [hud xmSetCustomModeWithResult:NO label:@"重置密码失败"];
                [hud hide:YES afterDelay:2];
            }];
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"验证码错误"];
            [hud hide:YES afterDelay:2];
        }
    }];
}

- (void)isEnableNext{
    if (self.textFiledPhone.text.length==11 && self.textFieldVerificationCode.text.length==6 && self.textFieldPasswd.text.length>5) {
        self.btnFinishResetPasswd.enabled = YES;
    }else{
        self.btnFinishResetPasswd.enabled = NO;
    }
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

- (void)timerReceiveSmsLaunch{
    if (!self.timerReceiveSms) {
        self.timeReceiveSmsCount = 59;
        
        self.timerReceiveSms = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            if (self.timeReceiveSmsCount<0) {
                [self.labelReceiveSms setText:@"获取验证码"];
                [self.timerReceiveSms invalidate];
                self.timerReceiveSms = nil;
                self.btnSendSms.enabled = YES;
            }else{
                [self.labelReceiveSms setText:[NSString stringWithFormat:@"重新获取(%lus)", self.timeReceiveSmsCount]];
            }
            self.timeReceiveSmsCount --;
        } repeats:YES];
        
    }
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
