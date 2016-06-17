//
//  ControllerRegister.m
//  IMeetU
//
//  Created by zhanghao on 16/3/6.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserRegisterFirstStep.h"
#import <YYKit/YYKit.h>
#import <YYKeyboardManager/YYKeyboardManager.h>

#import "XMInputViewFactory.h"
#import "XMInputViewGender.h"
#import "XMInputViewBirthday.h"

#import "XMAlertDialogRealProfile.h"

#import "UIView+Plug.h"
#import "NSDate+plug.h"
#import "ModelRequestRegister.h"

#import "ControllerUserRegisterSecondStep.h"

#import "XMOSS.h"
#import "XMUrlHttp.h"
#import "ModelResponse.h"
#import "AFNetworking.h"
#import "UserDefultAccount.h"
#import "MobClick.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"
#import "ModelResponseRegisterLogin.h"

#import "MBProgressHUD+plug.h"

#import "AppDelegate.h"

@interface ControllerUserRegisterFirstStep ()<XMInputViewGenderDelegate, XMInputViewGenderDataSource, XMInputViewBirthdayDelegate, XMAlertDialogRealProfileDelegate, YYKeyboardObserver>

@property (nonatomic, strong) ModelRequestRegister *modelRequestRegister;
@property (nonatomic, strong) UIImage *imgProfile;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UITextField *textNameNick;
@property (weak, nonatomic) IBOutlet UITextField *textGender;
@property (weak, nonatomic) IBOutlet UITextField *textBirthday;

@property (weak, nonatomic) IBOutlet UIButton *btnFinish;

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMainViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMainViewBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeaderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnGoalBottom;

@property (nonatomic, strong) YYKeyboardManager *keyboardManager;
@end

@implementation ControllerUserRegisterFirstStep

+ (instancetype)controllerWithModel:(ModelRequestRegister*)modelRequestRegister profile:(UIImage*)profile{
    ControllerUserRegisterFirstStep *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameAccount indentity:@"ControllerUserRegisterFirstStep"];
    controller.modelRequestRegister = modelRequestRegister;
    controller.imgProfile = profile;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraintViewHeaderHeight.constant = [self viewHeaderHeight];
    self.constraintBtnGoalBottom.constant = [self constantConstraintBtnActionBottom];
    
    XMInputViewGender *inputViewGender = [XMInputViewFactory xmInputViewGender];
    self.textGender.inputView = inputViewGender;
    inputViewGender.delegateXMInputView = self;
    inputViewGender.datasourceXMInputView = self;
    
    XMInputViewBirthday *inputViewBirthday = [XMInputViewFactory xmInputViewBirthday];
    self.textBirthday.inputView = inputViewBirthday;
    inputViewBirthday.delegateXMInputView = self;
    
    YYKeyboardManager *keyboardManager = [YYKeyboardManager defaultManager];
    [keyboardManager addObserver:self];
    
    UITapGestureRecognizer *tapGestureRecognizerViewMain = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickViewMain:)];
    [self.viewMain addGestureRecognizer:tapGestureRecognizerViewMain];
    
    [self.textNameNick addTarget:self action:@selector(onChangeTextFieldNameNick:) forControlEvents:UIControlEventEditingChanged];
    
    self.imgViewProfile.image = self.imgProfile;
    self.imgViewProfile.layer.cornerRadius = 40;
    self.imgViewProfile.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ControllerUserRegisterFirstStep"];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ControllerUserRegisterFirstStep"];
}

- (IBAction)onClickBtnFinish:(id)sender {
    //友盟账号统计:即将完成注册
    [MobClick event:@"register_finish_before"];
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"注册中..." animated:YES];
    
    [XMOSS uploadUserProfileWithImg:self.imgProfile progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
    } finish:^id(OSSTask *task, NSString *fileName) {
        if (!task.error) {
            self.modelRequestRegister.urlProfile = fileName;
            self.modelRequestRegister.urlProfileOriginal = fileName;
            self.modelRequestRegister.nameNick = self.textNameNick.text;
            self.modelRequestRegister.deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
            
            AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
            httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [httpManager POST:[XMUrlHttp xmRegister] parameters:self.modelRequestRegister.httpParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                
                if (response.state == 200) {
                    [hud xmSetCustomModeWithResult:YES label:@"注册成功"];
                    //友盟账号统计
                    [MobClick profileSignInWithPUID:self.modelRequestRegister.phone];
                    [MobClick event:@"register_finish"];
                    
                    ModelResponseRegisterLogin *responseData = [ModelResponseRegisterLogin modelWithJSON:response.data];
                    
                    [UserDefultAccount setUserName:responseData.userName];
                    [UserDefultAccount setUserCode:responseData.userCode];
                    [UserDefultAccount setUserProfileUrlThumbnail:responseData.userProfileUrl];
                    
                    [UserDefultAccount updateToken:responseData.token];
                    [UserDefultAccount setImName:responseData.imName];
                    [UserDefultAccount setImPasswork:responseData.imPasswork];
                    
                    //信鸽推送注册设备
                    [AppDelegate registerDeviceToken];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
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
                    //注册失败
                    [hud xmSetCustomModeWithResult:NO label:@"注册失败"];
                }
                [hud hide:YES afterDelay:0.3];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //网络请求失败
                [hud xmSetCustomModeWithResult:NO label:@"注册失败"];
                [hud hide:YES afterDelay:0.3];
            }];
        }else{
            //上传头像失败
            [hud xmSetCustomModeWithResult:NO label:@"注册失败"];
            [hud hide:YES afterDelay:0.3];
        }
        return nil;
    }];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickViewMain:(UITapGestureRecognizer*)gapGestureRecognizer{
    [self.viewMain endEditing:YES];
}

- (void)isEnableFinish{
    if (self.textNameNick.text.length>0 && self.textGender.text.length>0 && self.textBirthday.text.length>0 && self.imgProfile) {
        self.btnFinish.enabled = YES;
    }else{
        self.btnFinish.enabled = NO;
    }
}

- (void)onChangeTextFieldNameNick:(UITextField*)sender{
    [self isEnableFinish];
}

- (void)xmInputViewGenderInputWithGenderStr:(NSString *)genderStr genderNum:(NSInteger)genderNum{
    [self.textGender setText:genderStr];
    [self.textGender resignFirstResponder];
    self.modelRequestRegister.gender= genderNum;
    
    [self isEnableFinish];
}

- (NSInteger)initGenterInXmInputViewGender:(XMInputViewGender *)inputView{
    return self.modelRequestRegister.gender;
}

- (void)xmInputViewBirthdayInputWithBirthday:(NSDate *)birthday{
    NSString *birthdayStr = [NSString stringWithFormat:@"%li年%li月%li日", [birthday yearNumber], [birthday monthNumber], [birthday dayNumber]];
    [self.textBirthday setText:birthdayStr];
    [self.textBirthday resignFirstResponder];
    self.modelRequestRegister.birthday = [NSDate timeDateFormatYMD:birthday];
    
    [self isEnableFinish];
}


- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition{
    CGFloat constraintHeight;
    if (transition.toVisible) {
        constraintHeight = (transition.toFrame.size.height+20)-[self constantConstraintBtnActionBottom];
    }else{
        constraintHeight = 0;
    }
    
    [UIView animateWithDuration:transition.animationDuration animations:^{
        self.constraintMainViewTop.constant = -constraintHeight;
        self.constraintMainViewBottom.constant = constraintHeight;
        [self.view layoutIfNeeded]; //修改约束时需要添加此句
    }];
}

- (ModelRequestRegister*)modelRequestRegister{
    if (!_modelRequestRegister) {
        _modelRequestRegister = [[ModelRequestRegister alloc] init];
    }
    return _modelRequestRegister;
}

- (CGFloat)viewHeaderHeight{
    if ([UIScreen is35Screen]) {
        return 100;
    }
    return 170;
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
    return 10;
}

@end
