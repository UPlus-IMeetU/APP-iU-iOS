//
//  CellBiuMe.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellBiuMe.h"
#import "ModelBiuMe.h"
#import <YYKit/YYKit.h>
#import "DBSchools.h"
#import "UIColor+Plug.h"

@interface CellBiuMe()

@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelConstellation;
@property (weak, nonatomic) IBOutlet UILabel *labelSchool;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;

@property (nonatomic, weak) ModelBiuMe *model;
@end
@implementation CellBiuMe

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelNameNick.text = @"";
    self.labelAge.text = @"";
    self.labelConstellation.text = @"";
    self.labelSchool.text = @"";
    
    self.btnAccept.layer.cornerRadius = 3;
    self.btnAccept.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initWithModel:(ModelBiuMe *)model{
    self.model = model;
    [self.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:model.userProfile] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@""]];
    [self.labelNameNick setText:model.userName];
    [self.labelAge setText:[NSString stringWithFormat:@"%i岁", model.age]];
    [self.labelConstellation setText:model.constellation];
    [self.labelSchool setText:[[DBSchools shareInstance] schoolNameWithID:[model.schoolCode integerValue]]];
    
    self.btnAccept.enabled = !model.isAccept;
    if (model.isAccept) {
        [self.btnAccept setTitle:@"已接受" forState:UIControlStateNormal];
        [self.btnAccept setBackgroundColor:[UIColor colorWithR:128 G:128 B:128]];
    }else{
        [self.btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        [self.btnAccept setBackgroundColor:[UIColor often_33C6E5:1]];
    }
}

- (IBAction)onClickBtnProfile:(id)sender {
    if (self.delegateBiuMe) {
        if ([self.delegateBiuMe respondsToSelector:@selector(cell:onClickBtnProfile:)]) {
            [self.delegateBiuMe cell:self onClickBtnProfile:self.model];
        }
    }
}

- (IBAction)onClickBtnAccept:(id)sender {
    if (self.delegateBiuMe) {
        if ([self.delegateBiuMe respondsToSelector:@selector(cell:onClickBtnAccept:)]) {
            [self.delegateBiuMe cell:self onClickBtnAccept:self.model];
        }
    }
}


@end
