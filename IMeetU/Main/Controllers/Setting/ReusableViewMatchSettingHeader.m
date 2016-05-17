//
//  ReusableViewMatchSettingHeader.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ReusableViewMatchSettingHeader.h"
#import <YYKit/YYKit.h>
#import "UIScreen+Plug.h"
#import "ModelMatchSetting.h"

@interface ReusableViewMatchSettingHeader()

@property (weak, nonatomic) IBOutlet UISwitch *switchBoy;
@property (weak, nonatomic) IBOutlet UISwitch *switchGirl;
@property (weak, nonatomic) IBOutlet UISwitch *switchCityOne;
@property (weak, nonatomic) IBOutlet UISwitch *switchCityAll;



@property (nonatomic, assign) CGFloat chooseAgeMarginLeft;
@property (nonatomic, assign) CGFloat chooseAgeMarginRight;
@property (nonatomic, assign) CGFloat chooseAgeRange;

@property (nonatomic, assign) NSInteger ageFloor;
@property (nonatomic, assign) NSInteger ageCeiling;
@property (nonatomic, assign) NSInteger ageFloorSelected;
@property (nonatomic, assign) NSInteger ageCeilingSelected;

@property (weak, nonatomic) IBOutlet UILabel *labelAgeRange;
@property (weak, nonatomic) IBOutlet UIView *viewChooseAgeLeft;
@property (weak, nonatomic) IBOutlet UIView *viewChooseAgeRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintChooseAgeRangeLength;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintChooseAgeRangeMarginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintChooseAgeMarginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintChooseAgeMarginRight;

@end
@implementation ReusableViewMatchSettingHeader

- (void)awakeFromNib {
    [self initChooseAgeRange];
}

- (IBAction)onChangeSwitchBoy:(UISwitch*)sender {
    self.switchGirl.on = !sender.on;
    
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(reusableViewMatchSettingHeader:alterGender:)]) {
            [self.delegateReusableView reusableViewMatchSettingHeader:self alterGender:sender.on?1:2];
        }
    }
}
- (IBAction)onChangeSwitchGirl:(UISwitch*)sender {
    self.switchBoy.on = !sender.on;
    
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(reusableViewMatchSettingHeader:alterGender:)]) {
            [self.delegateReusableView reusableViewMatchSettingHeader:self alterGender:sender.on?2:1];
        }
    }
}
- (IBAction)onChangeSwitchCityOne:(UISwitch*)sender {
    self.switchCityAll.on = !sender.on;
    
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(reusableViewMatchSettingHeader:alterAreaRange:)]) {
            [self.delegateReusableView reusableViewMatchSettingHeader:self alterAreaRange:1];
        }
    }
}
- (IBAction)onChangeSwitchCityAll:(UISwitch*)sender {
    self.switchCityOne.on = !sender.on;
    
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(reusableViewMatchSettingHeader:alterAreaRange:)]) {
            [self.delegateReusableView reusableViewMatchSettingHeader:self alterAreaRange:2];
        }
    }
}

- (IBAction)onClickBtnChooseCharacter:(id)sender {
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(reusableViewMatchSettingHeaderAlterCharacter:)]){
            [self.delegateReusableView reusableViewMatchSettingHeaderAlterCharacter:self];
        }
    }
}

- (void)initWithModel:(ModelMatchSetting *)model{
    if (model.gender == 1) {
        self.switchBoy.on = YES;
        self.switchGirl.on = NO;
    }else if (model.gender == 2){
        self.switchBoy.on = NO;
        self.switchGirl.on = YES;
    }
    
    if (model.areaRange == 1) {
        self.switchCityOne.on = YES;
        self.switchCityAll.on = NO;
    }else if (model.areaRange == 2){
        self.switchCityOne.on = NO;
        self.switchCityAll.on = YES;
    }
   
    self.ageFloorSelected = model.ageFloor;
    self.ageCeilingSelected = model.ageCeiling;
    
    [self initChooseAgeRange];
}

- (void)initChooseAgeRange{
    float slidingRange = [UIScreen screenWidth] - 20*2;
    float step = slidingRange/(self.ageCeiling-self.ageFloor);
    self.constraintChooseAgeMarginLeft.constant = step*(self.ageFloorSelected-self.ageFloor)+20-25;
    self.constraintChooseAgeMarginRight.constant = step*(self.ageCeilingSelected-self.ageFloor)+20-25;
    self.constraintChooseAgeRangeMarginLeft.constant = self.constraintChooseAgeMarginLeft.constant+25;
    self.constraintChooseAgeRangeLength.constant = self.constraintChooseAgeMarginRight.constant-self.constraintChooseAgeMarginLeft.constant;
    [self.labelAgeRange setText:[NSString stringWithFormat:@"%lu岁-%lu岁", self.ageFloorSelected, self.ageCeilingSelected]];
    
    self.viewChooseAgeLeft.userInteractionEnabled = YES;
    self.viewChooseAgeRight.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGestureRecognizerChooseAgeLeft = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        UIPanGestureRecognizer *gestureRecognizer = sender;
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
            CGFloat margin = [gestureRecognizer locationInView:self].x-25;
            if (margin < self.constraintChooseAgeMarginRight.constant-step  &&  margin>20-25){
                self.constraintChooseAgeMarginLeft.constant = margin;
                self.constraintChooseAgeRangeMarginLeft.constant = self.constraintChooseAgeMarginLeft.constant+25;
                self.constraintChooseAgeRangeLength.constant = self.constraintChooseAgeMarginRight.constant-self.constraintChooseAgeMarginLeft.constant;
                self.ageFloorSelected = ((margin+25-20)/step+0.5)+self.ageFloor;
                [self.labelAgeRange setText:[NSString stringWithFormat:@"%lu岁-%lu岁", self.ageFloorSelected, self.ageCeilingSelected]];
            }
        }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
            if (self.delegateReusableView) {
                if ([self.delegateReusableView respondsToSelector:@selector(reusableViewMatchSettingHeader:alterAgeFloor:)]) {
                    [self.delegateReusableView reusableViewMatchSettingHeader:self alterAgeFloor:self.ageFloorSelected];
                }
            }
        }
    }];
    [self.viewChooseAgeLeft addGestureRecognizer:panGestureRecognizerChooseAgeLeft];
    
    UIPanGestureRecognizer *panGestureRecognizerChooseAgeRight = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        UIPanGestureRecognizer *gestureRecognizer = sender;
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
            CGFloat margin = [gestureRecognizer locationInView:self].x-25;
            if (margin > self.constraintChooseAgeMarginLeft.constant+step && margin<[UIScreen screenWidth]-20-25){
                self.constraintChooseAgeMarginRight.constant = margin;
                self.constraintChooseAgeRangeLength.constant = self.constraintChooseAgeMarginRight.constant-self.constraintChooseAgeMarginLeft.constant;
                self.ageCeilingSelected = ((margin+25-20)/step+0.5)+self.ageFloor;
                [self.labelAgeRange setText:[NSString stringWithFormat:@"%lu岁-%lu岁", self.ageFloorSelected, self.ageCeilingSelected]];
            }
        }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
            if (self.delegateReusableView) {
                if ([self.delegateReusableView respondsToSelector:@selector(reusableViewMatchSettingHeader:alterAgeCeiling:)]) {
                    [self.delegateReusableView reusableViewMatchSettingHeader:self alterAgeCeiling:self.ageCeilingSelected];
                }
            }
        }
    }];
    [self.viewChooseAgeRight addGestureRecognizer:panGestureRecognizerChooseAgeRight];
}

- (NSInteger)ageFloor{
    return 16;
}

- (NSInteger)ageCeiling{
    return 40;
}

- (NSInteger)ageCeilingSelected{
    if (_ageCeilingSelected > self.ageCeiling) {
        _ageCeilingSelected = self.ageCeiling;
    }
    if (_ageCeilingSelected<=self.ageFloorSelected) {
        _ageCeilingSelected = self.ageFloorSelected+1;
    }
    return _ageCeilingSelected;
}

- (NSInteger)ageFloorSelected{
    if (_ageFloorSelected < self.ageFloor) {
        _ageFloorSelected = self.ageFloor;
    }
    return _ageFloorSelected;
}

@end
