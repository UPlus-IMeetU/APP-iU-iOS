//
//  ControllerUserLogin.m
//  IMeetU
//
//  Created by zhanghao on 16/3/6.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserLogin.h"
#import <YYKit/YYKit.h>
#import <YYKeyboardManager/YYKeyboardManager.h>

#import "UIColor+Plug.h"
#import "UIStoryboard+Plug.h"
#import "ControllerUserLoginOrRegister.h"
#import "ControllerUserProtocol.h"
#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "ModelResponse.h"
#import "ModelResponseRegisterLogin.h"
#import "UserDefultAccount.h"

#import "MLToast.h"

#import "MBProgressHUD.h"
#import "UIScreen+Plug.h"
#import "AppDelegate.h"
#import "MBProgressHUD+plug.h"

#import <BQMM/BQMM.h>

@interface ControllerUserLogin ()<YYKeyboardObserver>

@property (weak, nonatomic) IBOutlet UITextField *textPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textPasswd;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeaderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnGoalBottom;

@property (nonatomic, strong) NSMutableAttributedString *strUserProtocol;

@end

@implementation ControllerUserLogin

+ (instancetype)controller{
    ControllerUserLogin *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameAccount indentity:@"ControllerUserLogin"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraintViewHeaderHeight.constant = [self viewHeaderHeight];
    self.constraintBtnGoalBottom.constant = [self constantConstraintBtnActionBottom];
    
    [[YYKeyboardManager defaultManager] addObserver:self];
    
    UITapGestureRecognizer *tapGestureRecognizerViewMain = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.viewMain endEditing:YES];
    }];
    [self.viewMain addGestureRecognizer:tapGestureRecognizerViewMain];
    
    [self.textPhoneNumber addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        [self isEnableNext];
    }];
    
    [self.textPasswd addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        [self isEnableNext];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnLogin:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"登录中..." animated:YES];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"phone":self.textPhoneNumber.text, @"password":self.textPasswd.text, @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"device_type":[NSNumber numberWithInt:4]};
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
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mbhud_yes"]];
            hud.labelText = @"登录成功";
            
            //信鸽推送注册设备
            [AppDelegate registerDeviceToken];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
            
            
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            dispatch_queue_t queue = dispatch_queue_create("tk.bourne.testQueue", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                EMError *error = [[EMClient sharedClient] loginWithUsername:responseData.imName password:responseData.imPasswork];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error){
                        
                    }else{
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"im登录失败";
                        [hud hide:YES afterDelay:1];
                    }
                });
                
            });
        }else{
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"登录失败..";
            [hud hide:YES afterDelay:1];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"登录失败.";
        [hud hide:YES afterDelay:1];
        
    }];
}


- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition{
    CGFloat viewMainConstraintConstant;
    if (transition.toVisible) {
        viewMainConstraintConstant = (transition.toFrame.size.height+20)-[self constantConstraintBtnActionBottom];
    }else{
        viewMainConstraintConstant = 0;
    }
    
    [UIView animateWithDuration:transition.animationDuration animations:^{
        self.constraintViewMainTop.constant = -viewMainConstraintConstant;
        self.constraintViewMainBottom.constant = viewMainConstraintConstant;
        [self.view layoutIfNeeded]; //修改约束时需要添加此句
    }];
}

- (void)isEnableNext{
    if (self.textPhoneNumber.text.length==11 && self.textPasswd.text.length>5) {
        self.btnLogin.enabled = YES;
    }else{
        self.btnLogin.enabled = NO;
    }
}

- (CGFloat)viewHeaderHeight{
    if ([UIScreen is35Screen]) {
        return 100;
    }
    return 210;
}

- (CGFloat)constantConstraintBtnActionBottom{
    if ([UIScreen is35Screen]) {
        return 66;
    }else if ([UIScreen is40Screen]){
        return 66;
    }else if ([UIScreen is47Screen]){
        return 160;
    }else if ([UIScreen is55Screen]){
        return 180;
    }
    return 10;
}

@end
