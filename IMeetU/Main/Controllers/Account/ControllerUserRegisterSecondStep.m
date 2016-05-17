//
//  ControllerRegisterSecondStep.m
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserRegisterSecondStep.h"
#import <YYKit/YYKit.h>
#import <YYKeyboardManager/YYKeyboardManager.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ControllerSelectSchool.h"

#import "XMInputViewFactory.h"
#import "XMInputViewCity.h"
#import "XMInputViewProfession.h"

#import "UIStoryboard+Plug.h"

#import "ModelRequestRegister.h"
#import "ControllerUserRegisterFirstStep.h"
#import "UIScreen+Plug.h"

#import "XMAlertDialogRealProfile.h"
#import "MLToast.h"

@interface ControllerUserRegisterSecondStep ()<YYKeyboardObserver, ControllerSelectSchoolDelegate, XMInputViewCityDelegate, XMAlertDialogRealProfileDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger isGraduated;
@property (nonatomic, strong) ControllerSelectSchool *controllerSelectSchool;
@property (nonatomic, strong) ModelRequestRegister *modelRequestRegister;
@property (nonatomic, strong) UIImage *imgProfile;

@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelAddProfile;
@property (weak, nonatomic) IBOutlet UIView *viewWillExamine;

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMainBottom;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewStudent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGraduate;
@property (weak, nonatomic) IBOutlet UITextField *textSchoolOrProfession;
@property (weak, nonatomic) IBOutlet UITextField *textCity;
//@property (weak, nonatomic) IBOutlet UIButton *btnSelectSchool;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;

//@property (weak, nonatomic) IBOutlet UIImageView *imgViewStudentGraduate;

@property (nonatomic, strong) UIImagePickerController *pickControllerProfile;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeaderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnGoalBottom;
@end

@implementation ControllerUserRegisterSecondStep

+ (instancetype)controllerWithModel:(ModelRequestRegister*)modelRequestRegister profile:(UIImage*)profile{
    ControllerUserRegisterSecondStep *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameAccount indentity:@"ControllerUserRegisterSecondStep"];
    controller.modelRequestRegister = modelRequestRegister;
    controller.imgProfile = profile;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraintViewHeaderHeight.constant = [self viewHeaderHeight];
    self.constraintBtnGoalBottom.constant = [self constantConstraintBtnActionBottom];
    
    //默认是学生
    self.modelRequestRegister.isGraduated = 1;
    
    self.btnProfile.layer.cornerRadius = 40;
    self.btnProfile.layer.masksToBounds = YES;
    
    self.viewWillExamine.hidden = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerViewMain = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.viewMain endEditing:YES];
    }];
    [self.viewMain addGestureRecognizer:tapGestureRecognizerViewMain];
    
    [[YYKeyboardManager defaultManager] addObserver:self];
    
    //默认注册者的身份是学生
    self.isGraduated = 1;
    
    self.controllerSelectSchool.delegateSelegateSchool = self;
    
    XMInputViewCity *xmInputViewCity = [XMInputViewFactory xmInputViewCity];
    xmInputViewCity.delegateXMInputView = self;
    self.textCity.inputView = xmInputViewCity;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)onClickBtnStudent:(id)sender {
    self.isGraduated = 1;
    self.modelRequestRegister.isGraduated = 1;
    [self.imgViewStudent setImage:[UIImage imageNamed:@"register_identity_selected"]];
    [self.imgViewGraduate setImage:[UIImage imageNamed:@"register_identity"]];
    
    [self isEnableNext];
}

- (IBAction)onClickBtnGraduate:(id)sender {
    self.isGraduated = 2;
    self.modelRequestRegister.isGraduated = 2;
    [self.imgViewStudent setImage:[UIImage imageNamed:@"register_identity"]];
    [self.imgViewGraduate setImage:[UIImage imageNamed:@"register_identity_selected"]];
    
    [self isEnableNext];
}

- (IBAction)onClickBtnSelectSchool:(id)sender {
    [self.navigationController pushViewController:self.controllerSelectSchool animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnNextStep:(id)sender {
    [self.view endEditing:YES];
    if (self.textSchoolOrProfession.text.length>0 && self.textCity.text.length>0 && self.imgProfile) {
        ControllerUserRegisterFirstStep *controller = [ControllerUserRegisterFirstStep controllerWithModel:self.modelRequestRegister profile:self.imgProfile];
        
//        UIViewController *controller = [[UIViewController alloc] init];
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 100, 100)];
//        btn.backgroundColor = [UIColor greenColor];
//        [btn setTitle:@"返回" forState:UIControlStateNormal];
//        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        [controller.view addSubview:btn];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [[MLToast toastInView:self.viewMain content:@"请上传头像..."] show];
    }
}

- (IBAction)onClickBtnProfile:(id)sender {
    [self.view endEditing:YES];
    
    XMAlertDialogRealProfile *alertDialog = [XMAlertDialogRealProfile alertDialog];
    alertDialog.delegateAlertDialog = self;
    [alertDialog showWithSuperView:self.view];
}

- (void)xmAlertDialogRealProfileOnClick:(XMAlertDialogRealProfile *)alertDialog{
    [self presentViewController:self.pickControllerProfile animated:YES completion:^{
        [alertDialog hiddenAndRemove];
    }];
}

#pragma mark - 选择头像回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        self.imgProfile = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.btnProfile setBackgroundImage:self.imgProfile forState:UIControlStateNormal];
        self.labelAddProfile.hidden = YES;
        self.viewWillExamine.hidden = NO;
        
        [self isEnableNext];
    }
    
    [self.pickControllerProfile dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.pickControllerProfile dismissViewControllerAnimated:YES completion:nil];
}

- (void)controllerSelectSchool:(ControllerSelectSchool *)controller schoolName:(NSString *)schoolName schoolId:(NSString *)schoolId{
    [self.textSchoolOrProfession setText:schoolName];
    [self.navigationController popViewControllerAnimated:YES];
    self.modelRequestRegister.schoolId = schoolId;
    
    [self isEnableNext];
}

- (void)xmInputViewCityInputWithAddress:(NSString *)address addressId:(NSString *)addressId cityNum:(NSString *)cityNum{
    [self.textCity setText:address];
    [self.textCity resignFirstResponder];
    self.modelRequestRegister.cityId = addressId;
    self.modelRequestRegister.cityNum = cityNum;
    
    [self isEnableNext];
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

- (void)isEnableNext{
    if (self.textSchoolOrProfession.text.length>0 && self.textCity.text.length>0 && self.imgProfile) {
        [self.btnNext setBackgroundImage:[UIImage imageNamed:@"login_register_btn_enable"] forState:UIControlStateNormal];
    }else{
        [self.btnNext setBackgroundImage:[UIImage imageNamed:@"login_register_btn_disable"] forState:UIControlStateNormal];
    }
}

- (ControllerSelectSchool *)controllerSelectSchool{
    if (!_controllerSelectSchool) {
        _controllerSelectSchool = [ControllerSelectSchool controllerViewSelectSchool];
    }
    return _controllerSelectSchool;
}

- (UIImagePickerController *)pickControllerProfile{
    if (!_pickControllerProfile) {
        _pickControllerProfile = [[UIImagePickerController alloc] init];
        _pickControllerProfile.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickControllerProfile.delegate = self;
        _pickControllerProfile.allowsEditing = YES;
    }
    return _pickControllerProfile;
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
    
    return 0;
}

@end
