//
//  ControllerMineAlterConstellation.m
//  MeetU
//
//  Created by zhanghao on 15/8/17.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerMineAlterConstellation.h"
#import "UIStoryboard+Plug.h"
#import "UIScreen+Plug.h"
#import "NSDate+plug.h"
#import "XMQueryConstellation.h"

@interface ControllerMineAlterConstellation()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, strong) NSDate *birthday;
@property (weak, nonatomic) IBOutlet UITextField *labelConstellation;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewConstellation;

@property (nonatomic, strong) NSArray *constellationArr;
@property (nonatomic, assign) float rowHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewHeight;
@end
@implementation ControllerMineAlterConstellation

+(instancetype)controllerMineAlterConstellation:(NSString *)constellation birthday:(NSDate *)birthday{
    ControllerMineAlterConstellation *controller = [UIStoryboard xmControllerWithName:@"Mine" indentity:@"ControllerMineAlterConstellation"];
    controller.constellation = constellation;
    controller.birthday = birthday;
    
    return controller;
}

- (void)viewDidLoad{
    self.pickerViewConstellation.delegate = self;
    self.pickerViewConstellation.dataSource = self;
    
    self.constraintpickViewTop.constant = [self pickViewTop];
    self.constraintpickViewHeight.constant = [self pickViewHeight];
}

- (void)viewDidAppear:(BOOL)animated{
    int row;
    if (self.constellation == nil) {
        self.constellation = [XMQueryConstellation constellationWithDate:[self.birthday currentTimeMillisSecond]];
    }
    
    for (row = 0; row < self.constellationArr.count; row++) {
        if (self.constellation == nil || self.constellation.length < 1) {
            break;
        }
        if ([self.constellation isEqual:self.constellationArr[row]]) {
            break;
        }
    }
    
    [self.pickerViewConstellation selectRow:row inComponent:0 animated:YES];
    self.labelConstellation.text = self.constellationArr[row];
    
}

- (NSArray *)constellationArr{
    if (_constellationArr == nil) {
        _constellationArr = [XMQueryConstellation constellations];
    }
    
    return _constellationArr;
}

- (float)rowHeight{
    return 40;
}

#pragma mark - UIPickerViewDelegate
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *labelConstellation = [[UILabel alloc] init];
    labelConstellation.frame = CGRectMake(0, 0, [UIScreen screenWidth]-40, self.rowHeight);
    labelConstellation.textAlignment = NSTextAlignmentCenter;
    
    labelConstellation.text = self.constellationArr[row];
    
    return labelConstellation;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.labelConstellation.text = self.constellationArr[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.rowHeight;
}
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 12;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSave:(id)sender {
    if (self.delegateAlterConstellation) {
        if ([self.delegateAlterConstellation respondsToSelector:@selector(controllerMineAlterConstellation:constellation:)]) {
            [self.delegateAlterConstellation controllerMineAlterConstellation:self constellation:self.labelConstellation.text];
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
