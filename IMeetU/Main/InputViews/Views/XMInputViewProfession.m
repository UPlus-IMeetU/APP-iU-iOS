//
//  XMInputViewProfession.m
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMInputViewProfession.h"

@interface XMInputViewProfession()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *professions;
@property (nonatomic, copy) NSString *profession;
@property (weak, nonatomic) IBOutlet UIPickerView *professionPick;

@end
@implementation XMInputViewProfession

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initial];
}

- (void)initial{
    self.professionPick.dataSource = self;
    self.professionPick.delegate = self;
    
    self.profession = [self professionWithIndex:0];
}

- (NSArray *)professions{
    if (!_professions) {
        _professions = @[
                         @"媒体/公关",
                         @"金融",
                         @"法律",
                         @"销售",
                         @"咨询",
                         @"IT/互联网/通信",
                         @"文化/艺术",
                         @"影视/娱乐",
                         @"教育/科研",
                         @"医疗/健康",
                         @"房地产/建筑",
                         @"政府机构"
                         ];
    }
    return _professions;
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.delegateInputView) {
        if ([self.delegateInputView respondsToSelector:@selector(xmInputViewProfession:profession:)]) {
            [self.delegateInputView xmInputViewProfession:self profession:self.profession];
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.professions.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self professionWithIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.profession = [self professionWithIndex:row];
}

- (NSString*)professionWithIndex:(NSInteger)index{
    if (index > self.professions.count) {
        return @"";
    }
    return self.professions[index];
}

@end
