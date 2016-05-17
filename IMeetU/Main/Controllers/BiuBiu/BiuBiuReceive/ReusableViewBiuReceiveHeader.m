//
//  ReusableViewBiuReceiveHeader.m
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ReusableViewBiuReceiveHeader.h"
#import "DBSchools.h"
#import <YYKit/YYKit.h>

@interface ReusableViewBiuReceiveHeader()

@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;

@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelMatch;
@property (weak, nonatomic) IBOutlet UILabel *labelBeforeTime;
@property (weak, nonatomic) IBOutlet UILabel *labelChatTopic;
@property (weak, nonatomic) IBOutlet UILabel *labelGender;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelConstellation;
@property (weak, nonatomic) IBOutlet UILabel *labelSchoolProfression;
@property (weak, nonatomic) IBOutlet UIButton *btnUserIdentifier;

@property (weak, nonatomic) IBOutlet UIView *viewProfileState;
@property (weak, nonatomic) IBOutlet UILabel *labelProfileState;

@property (nonatomic, weak) ModelBiuReceive *model;
@end
@implementation ReusableViewBiuReceiveHeader

- (void)awakeFromNib{
    [self.btnProfile setBackgroundImage:[UIImage imageNamed:@"global_profile_defult"] forState:UIControlStateNormal];
    self.labelNameNick.text = @"";
    self.labelDistance.text = @"";
    self.labelMatch.text = @"";
    self.labelBeforeTime.text = @"";
    self.labelChatTopic.text = @"";
    self.labelGender.text = @"";
    self.labelAge.text = @"";
    self.labelConstellation.text = @"";
    self.labelSchoolProfression.text = @"";
    
    self.btnUserIdentifier.hidden = YES;
}

- (void)initWithModel:(ModelBiuReceive *)model{
    self.model = model;
    
    [self.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:model.userProfile] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"global_profile_defult"]];
    [self.labelNameNick setText:model.nameNick];
    
    self.btnUserIdentifier.hidden = !self.model.userIdentifier;
    if (self.model.userIdentifier == 1) {
        [self.btnUserIdentifier setBackgroundImage:[UIImage imageNamed:@"global_special_user_icon_pink"] forState:UIControlStateNormal];
    }else if (self.model.userIdentifier == 2){
        [self.btnUserIdentifier setBackgroundImage:[UIImage imageNamed:@"global_special_user_icon_yellow"] forState:UIControlStateNormal];
    }else if (self.model.userIdentifier == 3){
        [self.btnUserIdentifier setBackgroundImage:[UIImage imageNamed:@"global_special_user_icon_blue"] forState:UIControlStateNormal];
    }
    
    if (model.profileState == 1) {
        self.viewProfileState.hidden = NO;
        self.labelProfileState.text = @"审核中";
    }else if (model.profileState == 2 || model.profileState == 3) {
        self.viewProfileState.hidden = YES;
    }else if (model.profileState == 4 || model.profileState == 5 || model.profileState == 6) {
        self.viewProfileState.hidden = NO;
        self.labelProfileState.text = @"未通过";
    }
    
    if (model.distance < 1000){
        self.labelDistance.text = [NSString stringWithFormat:@"%lum", model.distance];
    }else{
        self.labelDistance.text = [NSString stringWithFormat:@"%.1fkm", model.distance/1000.0];
    }
    
    self.labelMatch.text = [NSString stringWithFormat:@"%lu%%", model.matchingScore];
    
    self.labelBeforeTime.text = [NSString stringWithFormat:@"%lumin", model.timebefore];
    
    if (model.gender==1) {
        self.labelGender.text = @"男生";
    }else if (model.gender == 2){
        self.labelGender.text = @"女生";
    }else{
        self.labelGender.text = @"未知性别";
    }
    self.labelAge.text = [NSString stringWithFormat:@"%lu", model.age];
    
    if (model.constellation && model.constellation.length>0){
        self.labelConstellation.text = model.constellation;
    }else{
        
    }
    
    self.labelChatTopic.text = model.chatTopic;
    
    if (model.isGraduated==1) {
        NSString *schoolName = [[DBSchools shareInstance] schoolNameWithID:[model.schoolId integerValue]];
        if (schoolName.length > 6) {
            schoolName = [NSString stringWithFormat:@"%@...", [schoolName substringToIndex:6]];
        }
        self.labelSchoolProfression.text = schoolName;
    }else if (model.isGraduated==2) {
        if (model.profression.length > 6) {
            model.profression = [NSString stringWithFormat:@"%@...", [model.profression substringToIndex:6]];
        }
        self.labelSchoolProfression.text = model.profression;
    }
}

- (IBAction)onClickProfile:(id)sender {
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(reusableViewBiuReceiveHeader:profileUrl:)]) {
            [self.delegateReusableView reusableViewBiuReceiveHeader:self profileUrl:self.model.userProfileOrigin];
        }
    }
}


- (IBAction)onClickBtnUserIdentifier:(id)sender {
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(reusableViewBiuReceiveHeader:onClickBtnUserIdentifier:)]) {
            [self.delegateReusableView reusableViewBiuReceiveHeader:self onClickBtnUserIdentifier:sender];
        }
    }
}

@end
