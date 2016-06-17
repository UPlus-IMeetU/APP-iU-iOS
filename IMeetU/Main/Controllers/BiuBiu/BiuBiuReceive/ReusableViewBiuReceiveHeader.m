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
#import "UIColor+plug.h"
#import "NSDate+MJ.h"

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

@property (weak, nonatomic) IBOutlet UIButton *topicButton;
@property (weak, nonatomic) IBOutlet UIButton *hobbyButton;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

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
    self.labelChatTopic.textColor = [UIColor colorWithR:51 G:51 B:51 A:1];
    self.btnUserIdentifier.hidden = YES;
    
    [self.topicButton setTitleColor:[UIColor oftenOrange] forState:UIControlStateNormal];
    self.topicButton.layer.cornerRadius = self.topicButton.height * 0.5;
    self.topicButton.layer.borderWidth = 0.5;
    self.topicButton.layer.borderColor = [UIColor oftenOrange].CGColor;
    self.topicButton.clipsToBounds = YES;
    
    [self.hobbyButton setTitleColor:[UIColor oftenOrange] forState:UIControlStateNormal];
    self.hobbyButton.layer.cornerRadius = self.hobbyButton.height * 0.5;
    self.hobbyButton.layer.borderWidth = 0.5;
    self.hobbyButton.layer.borderColor = [UIColor oftenOrange].CGColor;
    self.hobbyButton.clipsToBounds = YES;
    [self.dropDownButton setImage:[UIImage imageNamed:@"biu_receive_btn_down"] forState:UIControlStateNormal];
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
    }else if (model.profileState == 3) {
        self.viewProfileState.hidden = YES;
    }else if ( model.profileState == 5) {
        self.viewProfileState.hidden = NO;
        self.labelProfileState.text = @"未通过";
    }
    
    if (model.distance < 1000){
        self.labelDistance.text = [NSString stringWithFormat:@"%lum", (long)model.distance];
    }else{
        self.labelDistance.text = [NSString stringWithFormat:@"%.1fkm", model.distance/1000.0];
    }
    
    self.labelMatch.text = [NSString stringWithFormat:@"%lu%%", (long)model.matchingScore];
    
    self.labelBeforeTime.text = [self createdAt:model.timebefore];
    if (model.gender==1) {
        self.labelGender.text = @"男生";
    }else if (model.gender == 2){
        self.labelGender.text = @"女生";
    }else{
        self.labelGender.text = @"未知性别";
    }
    self.labelAge.text = [NSString stringWithFormat:@"%lu", (long)model.age];
    
    if (model.constellation && model.constellation.length>0){
        self.labelConstellation.text = model.constellation;
    }else{
        
    }
    
    self.labelChatTopic.text = model.chatTopic;
    
        NSString *schoolName = [[DBSchools shareInstance] schoolNameWithID:[model.schoolId integerValue]];
        if (schoolName.length > 6) {
            schoolName = [NSString stringWithFormat:@"%@...", [schoolName substringToIndex:6]];
        }
        self.labelSchoolProfression.text = schoolName;
}


- (NSString *)createdAt:(long long)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //2015-09-08 18:05:31
    fmt.dateFormat = @"yyyyMMddHHmmss";
    //#warning 真机调试的时候，必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 获得微博发布的具体时间
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:(time/1000)];
    // 判断是否为今年
    if (createDate.isThisYear) {
        NSDateComponents *cmps = [createDate deltaWithNow];
        if (createDate.isToday) { // 今天
            
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (cmps.day > 1 && cmps.day <= 7) { // 昨天
            return [NSString stringWithFormat:@"%ld天前",(long)cmps.day];
        } else if (cmps.day > 7){
            fmt.dateFormat = @"MM月dd日";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy年MM月dd日";
        return [fmt stringFromDate:createDate];
    }
    return nil;
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
- (IBAction)dropDownButtonClick:(id)sender {
    if (self.delegateReusableView) {
        if ([self.delegateReusableView respondsToSelector:@selector(resuableViewBiuReceiveHeader:onClickDropDown:)]) {
            [self.delegateReusableView resuableViewBiuReceiveHeader:self onClickDropDown:sender];
        }
    }
}

@end
