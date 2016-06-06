//
//  CellBiuAccept.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellBiuAccept.h"
#import "ModelBiuAccept.h"
#import <YYKit/YYKit.h>
#import "DBSchools.h"
#import "UIColor+Plug.h"

@interface CellBiuAccept()

@property (weak, nonatomic) IBOutlet UIButton *btnUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelConstellation;
@property (weak, nonatomic) IBOutlet UILabel *labelSchool;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelCountOfUmi;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;

@property (nonatomic, weak) ModelBiuAccept *model;

@end
@implementation CellBiuAccept

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelStatus.layer.cornerRadius = 4;
    self.labelStatus.layer.masksToBounds = YES;
}

- (void)initWithModel:(ModelBiuAccept*)model{
    self.model = model;
    
    [self.btnUserProfile setBackgroundImageWithURL:[NSURL URLWithString:model.urlProfile] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"global_profile_defult"]];
    
    [self.labelName setText:model.nameNick];
    [self.labelAge setText:[NSString stringWithFormat:@"%lu", model.age]];
    [self.labelConstellation setText:model.constellation];
    [self.labelSchool setText:[[DBSchools shareInstance] schoolNameWithID:[model.schoolID integerValue]]];
    if (model.status) {
        //已被接受
        self.btnAccept.enabled = NO;
        self.labelStatus.backgroundColor = [UIColor colorWithR:176 G:176 B:176];
        [self.labelStatus setText:@"已接受"];
    }else{
        self.btnAccept.enabled = YES;
        self.labelStatus.backgroundColor = [UIColor often_6CD1C9:1.0];
        [self.labelStatus setText:@"接受"];
    }
    
    if (model.virtualCurrency) {
        [self.labelCountOfUmi setText:[NSString stringWithFormat:@"已赠%luU米", model.virtualCurrency]];
    }else{
        [self.labelCountOfUmi setText:@""];
    }
}

- (void)setAlreadyAccept{
    self.btnAccept.enabled = NO;
    self.labelStatus.backgroundColor = [UIColor colorWithR:176 G:176 B:176];
    [self.labelStatus setText:@"已接受"];
    
    self.model.status = 1;
}

- (IBAction)onClickBtnProfile:(id)sender {
    if (self.delegateCellAccept) {
        if ([self.delegateCellAccept respondsToSelector:@selector(cellBiuAccept:onClickBtnProfile:)]) {
            [self.delegateCellAccept cellBiuAccept:self onClickBtnProfile:self.model];
        }
    }
}

- (IBAction)onClickBtnAccept:(id)sender {
    if (self.delegateCellAccept) {
        if ([self.delegateCellAccept respondsToSelector:@selector(cellBiuAccept:onClickBtnAccept:)]) {
            [self.delegateCellAccept cellBiuAccept:self onClickBtnAccept:self.model];
        }
    }
}

@end
