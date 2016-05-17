//
//  ControllerMyAlterHometown.m
//  MeetU
//
//  Created by zhanghao on 15/8/13.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerMineAlterAddress.h"

#import "UIStoryboard+Plug.h"
#import "UIScreen+Plug.h"

#import "DBCity.h"
#import "ModelCity.h"

@interface ControllerMineAlterAddress ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *operateStr;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHometown;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerHometown;

@property (weak, nonatomic) IBOutlet UILabel *labelTitleNavigation;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *labelTitlePickView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintpickViewHeight;

@property (nonatomic, strong) ModelCity *modelCity;
@property (nonatomic, assign) NSInteger pRow;
@property (nonatomic, assign) NSInteger cRow;
@property (nonatomic, assign) NSInteger tRow;

@end

@implementation ControllerMineAlterAddress

+(instancetype)controllerMyAlterAddress:(NSString *)addressId operateStr:(NSString *)operateStr{
    ControllerMineAlterAddress *controller = [UIStoryboard xmControllerWithName:@"Mine" indentity:@"ControllerMineAlterHometown"];
    controller.addressId = addressId;
    controller.operateStr = operateStr;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerHometown.delegate = self;
    self.pickerHometown.dataSource = self;
    
    if ([@"City" isEqualToString:self.operateStr]) {
        [self.labelTitleNavigation setText:@"所在城市"];
        [self.labelTitleTextField setText:@"城市"];
        [self.labelTitlePickView setText:@"选择城市"];
    }else if ([@"HomeTown" isEqualToString:self.operateStr]){
        [self.labelTitleNavigation setText:@"我的家乡"];
        [self.labelTitleTextField setText:@"家乡"];
        [self.labelTitlePickView setText:@"选择家乡"];
    }
    
    NSString *address = [DBCity addressWithId:self.addressId];
    self.textFieldHometown.text = address;
    
    self.constraintpickViewTop.constant = [self pickViewTop];
    self.constraintpickViewHeight.constant = [self pickViewHeight];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.addressId) {
        NSDictionary *addressDic = [DBCity addressDicWithId:self.addressId];
        NSString *pName = addressDic[@"province"];
        NSString *cName = addressDic[@"city"];
        
        self.pRow = [DBCity selectIndexOfProvince:pName];
        self.cRow = [DBCity selectIndexOfCity:cName province:pName];
        
        if (self.pRow!=NSNotFound && self.cRow!=NSNotFound) {
            [self.pickerHometown selectRow:self.pRow inComponent:0 animated:YES];
            [self.pickerHometown selectRow:self.cRow inComponent:1 animated:YES];
        }
    }
}

- (ModelCity *)modelCity{
    if (_modelCity == nil) {
        if (self.addressId) {
            NSDictionary *addressDic = [DBCity addressDicWithId:self.addressId];
            NSString *pName = addressDic[@"province"];
             _modelCity = [ModelCity modelCityWithProvince:pName];
        }else{
            _modelCity = [ModelCity modelCity];
        }
    }
    
    return _modelCity;
}

#pragma mark - UIPickerViewDelegate
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *labelAddress = [[UILabel alloc] init];
    NSString *address = [self.modelCity nameWithRow:row component:component];
    
    CGRect rect = CGRectMake(0, 0, ([UIScreen screenWidth]-40)/2, 28);
    labelAddress.textAlignment = NSTextAlignmentCenter;
    labelAddress.frame = rect;
    
    labelAddress.text = address;
    
    return labelAddress;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.pRow = row;
        [self.modelCity updateCityWithProvince:[self.modelCity provinceForIndex:self.pRow]];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.cRow = 0;
    }else if(component == 1){
        self.cRow = row;
    }
    
    NSString *pName = [self.modelCity provinceForIndex:self.pRow];
    NSString *cName = [self.modelCity cityForIndex:self.cRow];
    [self.textFieldHometown setText:[NSString stringWithFormat:@"%@  %@", pName, cName]];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.modelCity countWithComponent:component];
}


- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSave:(id)sender {
    NSString *addressId = @"";
    NSString *addressName = @"";
    NSString *cityNum = @"";
    if (self.textFieldHometown.text && self.textFieldHometown.text.length>0) {
        NSString *pName = [self.modelCity provinceForIndex:self.pRow];
        NSString *cName = [self.modelCity cityForIndex:self.cRow];
        cityNum = [NSString stringWithFormat:@"%lu", [self.modelCity cityNumForIndex:self.cRow]];
        
        addressName = [NSString stringWithFormat:@"%@ %@", pName, cName];
        addressId = [self.modelCity addressIdWithProvince:pName city:cName];
    }
    
    if (self.delegateAlterAddress) {
        if ([self.delegateAlterAddress respondsToSelector:@selector(controllerMineAlterAddress:address:addressId:cityNum:operateStr:)]) {
            [self.delegateAlterAddress controllerMineAlterAddress:self address:addressName addressId:addressId cityNum:cityNum operateStr:self.operateStr];
            
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
