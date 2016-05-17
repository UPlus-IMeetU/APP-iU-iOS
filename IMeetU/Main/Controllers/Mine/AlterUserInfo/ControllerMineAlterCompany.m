//
//  ControllerMineAlterICompany.m
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMineAlterCompany.h"
#import "UIStoryboard+Plug.h"
#import <YYKit/YYKit.h>

@interface ControllerMineAlterCompany ()

@property (nonatomic, copy) NSString *companyName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCompany;
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyLength;

@end

@implementation ControllerMineAlterCompany

+ (instancetype)controllerWithCompany:(NSString *)company{
    ControllerMineAlterCompany *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMineAlterCompany"];
    controller.companyName = company;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textFieldCompany setText:self.companyName];
    [self.labelCompanyLength setText:[NSString stringWithFormat:@"%lu/16", self.companyName.length]];
    
    [self.textFieldCompany addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        if (self.textFieldCompany.text.length > 16) {
            self.textFieldCompany.text = [self.textFieldCompany.text substringToIndex:16];
        }
        [self.labelCompanyLength setText:[NSString stringWithFormat:@"%lu/16", self.textFieldCompany.text.length]];
    }];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.delegateAlterCompany) {
        if ([self.delegateAlterCompany respondsToSelector:@selector(controllerMineAlterCompany:company:)]) {
            [self.delegateAlterCompany controllerMineAlterCompany:self company:self.textFieldCompany.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
