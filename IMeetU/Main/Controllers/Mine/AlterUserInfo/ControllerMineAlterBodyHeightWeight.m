//
//  ControllerMineAlterBodyHeightWeight.m
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMineAlterBodyHeightWeight.h"

#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

@interface ControllerMineAlterBodyHeightWeight ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelBodyHeightWeight;
@property (weak, nonatomic) IBOutlet UIPickerView *pickViewHeightWeight;

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger heightFloor;
@property (nonatomic, assign) NSInteger heightRange;
@property (nonatomic, assign) NSInteger weightFloor;
@property (nonatomic, assign) NSInteger weightRange;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewHeight;
@end

@implementation ControllerMineAlterBodyHeightWeight

+ (instancetype)controllerWithHeight:(NSInteger)height weight:(NSInteger)weight{
    ControllerMineAlterBodyHeightWeight *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMineAlterBodyHeightWeight"];
    controller.height = height;
    controller.weight = weight;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.labelBodyHeightWeight setText:[NSString stringWithFormat:@"%lucm   %lukg", self.height, self.weight]];
    
    self.pickViewHeightWeight.dataSource = self;
    self.pickViewHeightWeight.delegate = self;
    
    self.constraintpickViewTop.constant = [self pickViewTop];
    self.constraintpickViewHeight.constant = [self pickViewHeight];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.pickViewHeightWeight selectRow:self.height-self.heightFloor inComponent:0 animated:YES];
    [self.pickViewHeightWeight selectRow:self.weight-self.weightFloor inComponent:1 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.heightRange;
    }else if (component==1){
        return self.weightRange;
    }
    
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [NSString stringWithFormat:@"%lucm", self.heightFloor+row];
    }else if (component==1){
        return [NSString stringWithFormat:@"%lukg", self.weightFloor+row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.height = self.heightFloor+row;
    }else if (component == 1){
        self.weight = self.weightFloor+row;
    }
    
    [self.labelBodyHeightWeight setText:[NSString stringWithFormat:@"%lucm   %lukg", self.height, self.weight]];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.delegateAlterBodyHeightWeight) {
        if ([self.delegateAlterBodyHeightWeight respondsToSelector:@selector(controllerMineAlterBodyHeightWeight:height:weight:)]) {
            [self.delegateAlterBodyHeightWeight controllerMineAlterBodyHeightWeight:self height:self.height weight:self.weight];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (NSInteger)height{
    if (_height < self.heightFloor || _height > self.heightFloor+self.heightRange) {
        return self.heightFloor+self.heightRange/2;
    }
    
    return _height;
}

- (NSInteger)weight{
    if (_weight<self.weightFloor || _weight > self.weightFloor+self.weightRange) {
        return self.weightFloor+self.weightRange/2;
    }
    
    return _weight;
}

- (NSInteger)heightFloor{
    return 120;
}

- (NSInteger)heightRange{
    return 100;
}

- (NSInteger)weightFloor{
    return 30;
}

- (NSInteger)weightRange{
    return 120;
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
