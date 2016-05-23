//
//  CellBiuContact.m
//  IMeetU
//
//  Created by zhanghao on 16/3/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellBiuContact.h"
#import "ModelContact.h"
#import <YYKit/YYKit.h>

@interface CellBiuContact()

@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelConstellation;
@property (weak, nonatomic) IBOutlet UILabel *labelSchoolOrProfession;

@property (nonatomic, strong) ModelContact *contact;

@end
@implementation CellBiuContact

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelNameNick.text = @"";
    self.labelAge.text = @"";
    self.labelConstellation.text = @"";
    self.labelSchoolOrProfession.text = @"";
}

- (void)initWithModel:(ModelContact *)model{
    self.contact = model;
    
    self.labelNameNick.text = model.nameNick;
    self.labelAge.text = [NSString stringWithFormat:@"%lu岁", model.age];
    self.labelConstellation.text = model.constellation;
    self.labelSchoolOrProfession.text = model.schoolName;
    
    [self.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:model.profileUrl] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"global_profile_defult"]];
}


- (IBAction)onClickBtnProfile:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellBiuContact:onClickProfile:)]) {
            [self.delegateCell cellBiuContact:self onClickProfile:self.contact];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
