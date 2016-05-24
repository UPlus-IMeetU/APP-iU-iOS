//
//  MatchPeopleCell.m
//  IMeetU
//
//  Created by Spring on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "MatchPeopleCell.h"
#import "YYKit/YYKit.h"
#import "DBSchools.h"
#import "NSDate+MJ.h"



@interface MatchPeopleCell()
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet YYLabel *biubiuInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@end

@implementation MatchPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setMatchPeople:(ModelUserMatch *)matchPeople{
    _matchPeople = matchPeople;
    [_headPortrait setImageWithURL:[NSURL URLWithString:_matchPeople.urlProfileThumbnail] placeholder:[UIImage imageNamed:@"chatListCellHead"]];
    _userName.text = _matchPeople.nameNick;
    _biubiuInfoLabel.text = _matchPeople.topic;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_matchPeople.topic];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_matchPeople.topic length])];
    _biubiuInfoLabel.attributedText = attributedString;
    [_biubiuInfoLabel sizeToFit];
    _timeLabel.text = [self createdAt:_matchPeople.timeSendBiu];
    _matchLabel.text = [NSString stringWithFormat:@"%ld%%",(long)_matchPeople.matchScore];
    NSString *schoolName = [self searchSchoolNameWithID:_matchPeople.schoolID];
    if (!schoolName) {
        _userInfo.text = [NSString stringWithFormat:@"%ld岁",(long)_matchPeople.age];
    }else{
        _userInfo.text = [NSString stringWithFormat:@"%@ • %ld岁",schoolName,(long)_matchPeople.age];
    }
    
    if (_matchPeople.distanceToMe < 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%lum", (long)_matchPeople.distanceToMe];
    }else{
        if (_matchPeople.distanceToMe/1000.0 <= 10) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",_matchPeople.distanceToMe/1000.0];
        }else{
            self.distanceLabel.text = [NSString stringWithFormat:@"%dkm",_matchPeople.distanceToMe/1000];
        }
    }
    
    if (_matchPeople.gender == 1) {
        [_sexImageView setImage:[UIImage imageNamed:@"biu_ago_icon_sex_boy"]];
    }else{
        [_sexImageView setImage:[UIImage imageNamed:@"biu_ago_sex_girl"]];
    }
}


//获取学校
- (NSString *)searchSchoolNameWithID:(NSInteger)schoolID{
    DBSchools *dbSchools = [DBSchools shareInstance];
    return [[dbSchools schoolWithID:schoolID] objectForKey:@"schoolName"];
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
@end
