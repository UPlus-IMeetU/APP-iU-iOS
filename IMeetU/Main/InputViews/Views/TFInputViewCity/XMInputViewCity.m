//
//  TFInputViewCity.m
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMInputViewCity.h"
#import "ModelCity.h"
#import "UIScreen+Plug.h"

@interface XMInputViewCity()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;
@property (weak, nonatomic) IBOutlet UIButton *btnFinsh;

@property (nonatomic, strong) ModelCity *modelCity;
@property (nonatomic, assign) NSInteger pRow;
@property (nonatomic, assign) NSInteger cRow;
@end
@implementation XMInputViewCity

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.cityPickerView.delegate = self;
    self.cityPickerView.dataSource = self;
    self.modelCity = [ModelCity modelCity];
}

- (IBAction)onClickBtnFinsh:(id)sender {
    
    //执行委托方法
    if (self.delegateXMInputView != nil) {
        if ([self.delegateXMInputView respondsToSelector:@selector(xmInputViewCityInputWithAddress:addressId:cityNum:)]) {
            NSString *pName = [self.modelCity provinceForIndex:self.pRow];
            NSString *cName = [self.modelCity cityForIndex:self.cRow];
            NSString *cityNum = [NSString stringWithFormat:@"%lu",[self.modelCity cityNumForIndex:self.cRow]];
            
            NSString *address = [NSString stringWithFormat:@"%@ %@", pName, cName];
            NSString *addressId = [self.modelCity addressIdWithProvince:pName city:cName];
            
            
            [self.delegateXMInputView xmInputViewCityInputWithAddress:address addressId:addressId cityNum:cityNum];
        }
    }
}

#pragma mark - datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.modelCity countWithComponent:component];
}

#pragma mark - delegate

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *labelAddress = [[UILabel alloc] init];
    NSString *address = [self.modelCity nameWithRow:row component:component];
    
    CGRect rect = CGRectMake(0, 0, [UIScreen screenWidth]/3, 28);
    labelAddress.textAlignment = NSTextAlignmentCenter;
    labelAddress.frame = rect;
    
    if (component == 0) {
        if (address.length > 3) {
            address = [address substringWithRange:NSMakeRange(0, 3)];
        }
    }else{
        if (address.length > 5) {
            address = [address substringWithRange:NSMakeRange(0, 5)];
        }
    }
    
    labelAddress.text = address;
    
    return labelAddress;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return [UIScreen screenWidth]/3;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.pRow = row;
        [self.modelCity updateCityWithProvince:[self.modelCity provinceForIndex:self.pRow]];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.cRow = 0;
        [self.modelCity updateTownWithCity:[self.modelCity cityForIndex:self.cRow]];
    }else if (component == 1){
        self.cRow = row;
    }
}
@end
