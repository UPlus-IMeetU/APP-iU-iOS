//
//  ControllerMineAlterIdentity.m
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMineAlterIdentityProfession.h"

#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"
#import "ControllerSelectSchool.h"

@interface ControllerMineAlterIdentityProfession ()<ControllerSelectSchoolDelegate>

@property (nonatomic, assign) NSInteger isGraduated;
@property (nonatomic, copy) NSString *profession;
@property (weak, nonatomic) IBOutlet UILabel *labelIdentityProfession;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewStudent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGraduate;

@end

@implementation ControllerMineAlterIdentityProfession

+ (instancetype)controllerWithProfession:(NSString *)profession isGraduated:(NSInteger)isGraduated{
    ControllerMineAlterIdentityProfession *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMineAlterIdentityProfession"];
    controller.isGraduated = isGraduated;
    controller.profession = profession;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isGraduated == 1){
        [self.labelIdentityProfession setText:@"学生党"];
        [self.imgViewStudent setImage:[UIImage imageNamed:@"register_identity_selected"]];
        [self.imgViewGraduate setImage:[UIImage imageNamed:@"register_identity"]];
    }else if (self.isGraduated == 2){
        [self.labelIdentityProfession setText:@"毕业族"];
        [self.imgViewStudent setImage:[UIImage imageNamed:@"register_identity"]];
        [self.imgViewGraduate setImage:[UIImage imageNamed:@"register_identity_selected"]];
    }
    
    self.constraintpickViewTop.constant = [self pickViewTop];
    self.constraintpickViewHeight.constant = [self pickViewHeight];
}

- (IBAction)onClickBtnStudent:(id)sender {
    self.isGraduated = 1;
    [self.labelIdentityProfession setText:@"学生党"];
    [self.imgViewStudent setImage:[UIImage imageNamed:@"register_identity_selected"]];
    [self.imgViewGraduate setImage:[UIImage imageNamed:@"register_identity"]];
    
}

- (IBAction)onClickBtnGraduate:(id)sender {
    self.isGraduated = 2;
    [self.labelIdentityProfession setText:@"毕业族"];
    [self.imgViewStudent setImage:[UIImage imageNamed:@"register_identity"]];
    [self.imgViewGraduate setImage:[UIImage imageNamed:@"register_identity_selected"]];
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.delegateAlterIdentityProfession) {
        if ([self.delegateAlterIdentityProfession respondsToSelector:@selector(controllerMineAlterIdentityProfession:isGraduated:profession:schoolId:schoolName:)]) {
            [self.delegateAlterIdentityProfession controllerMineAlterIdentityProfession:self isGraduated:self.isGraduated profession:self.profession schoolId:nil schoolName:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)controllerSelectSchool:(ControllerSelectSchool *)controller schoolName:(NSString *)schoolName schoolId:(NSString *)schoolId{
    if (self.delegateAlterIdentityProfession) {
        if ([self.delegateAlterIdentityProfession respondsToSelector:@selector(controllerMineAlterIdentityProfession:isGraduated:profession:schoolId:schoolName:)]) {
            
            [self.delegateAlterIdentityProfession controllerMineAlterIdentityProfession:self isGraduated:self.isGraduated profession:self.profession schoolId:schoolId schoolName:schoolName];
            
            [self.navigationController popToViewController:self.previousController animated:YES];
        }
    }
}

- (CGFloat)pickViewTop{
    if ([UIScreen is35Screen] || [UIScreen is40Screen]) {
        return 30;
    }
    return 60;
}

- (CGFloat)pickViewHeight{
    if ([UIScreen is35Screen]) {
        return 220;
    }
    return 300;
}

@end
