//
//  ControllerMyAlterBirthday.m
//  MeetU
//
//  Created by zhanghao on 15/8/13.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerMineAlterBirthday.h"

#import "UIStoryboard+Plug.h"

#import "NSDate+plug.h"
#import "UIScreen+Plug.h"

@interface ControllerMineAlterBirthday ()

@property (nonatomic, strong) NSDate *birthday;
@property (weak, nonatomic) IBOutlet UILabel *labelBirthday;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerBirthday;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewHeight;

@end

@implementation ControllerMineAlterBirthday

+(instancetype)controllerMyAlterBirthdayWithDate:(NSDate *)birthday{
    ControllerMineAlterBirthday *controller = [UIStoryboard xmControllerWithName:@"Mine" indentity:@"ControllerMineAlterBirthday"];
    controller.birthday = birthday;
    
    return controller;
}

- (void)viewDidLoad{
    self.constraintpickViewTop.constant = [self pickViewTop];
    self.constraintpickViewHeight.constant = [self pickViewHeight];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.datePickerBirthday addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];

    if (self.birthday) {
        self.datePickerBirthday.date = self.birthday;
        self.labelBirthday.text = [NSDate timeDateFormatYMD:self.birthday];
    }else{
        self.datePickerBirthday.date = [NSDate dateWithTimeIntervalSinceNow:0];
        self.labelBirthday.text = [NSDate timeDateFormatYMD:[NSDate dateWithTimeIntervalSinceNow:0]];
    }

}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

- (void)datePickerValueChange:(UIDatePicker*)datePicker{
    NSDate *now = datePicker.date;
    
    self.labelBirthday.text = [NSDate timeDateFormatYMD:now];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSave:(id)sender {
    if (self.delegateAlterBirthday) {
        if ([self.delegateAlterBirthday respondsToSelector:@selector(controllerMineAlterBirthday:birthday:)]) {
            [self.delegateAlterBirthday controllerMineAlterBirthday:self birthday:self.datePickerBirthday.date];
            [self.navigationController popViewControllerAnimated:YES];
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
