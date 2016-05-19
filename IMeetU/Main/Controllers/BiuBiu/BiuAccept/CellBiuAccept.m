//
//  CellBiuAccept.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellBiuAccept.h"

@interface CellBiuAccept()

@property (weak, nonatomic) IBOutlet UIButton *btnUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelConstellation;
@property (weak, nonatomic) IBOutlet UILabel *labelSchool;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelCountOfUmi;


@end
@implementation CellBiuAccept

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelStatus.layer.cornerRadius = 4;
    self.labelStatus.layer.masksToBounds = YES;
}

- (void)initWith{
    
}

- (IBAction)onClickBtnProfile:(id)sender {
}

- (IBAction)onClickBtnAccept:(id)sender {
}

@end
