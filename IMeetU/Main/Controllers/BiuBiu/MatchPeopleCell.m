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
#import "NSDate+plug.h"
@interface MatchPeopleCell()
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *userSex;
@property (weak, nonatomic) IBOutlet UILabel *biubiuInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation MatchPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMatchPeople:(MatchPeople *)matchPeople{
    _matchPeople = matchPeople;
    //进行页面的初始化
    [_headPortrait setImageWithURL:[NSURL URLWithString:_matchPeople.icon_thumbnailUrl] options:YYWebImageOptionShowNetworkActivity];
    _userName.text = _matchPeople.nickname;
    _biubiuInfoLabel.text = _matchPeople.chat_tags;
    _timeLabel.text = [NSString stringWithFormat:@"%f",_matchPeople.time];
    _distanceLabel.text = [NSString stringWithFormat:@"%d",_matchPeople.distance];
    _matchLabel.text = [NSString stringWithFormat:@"%@%%",_matchPeople.matching_score];
    
    //查询学校
    NSString *schoolName = [self searchSchoolNameWithID:[_matchPeople.school integerValue]];
    if (!schoolName) {
        _userInfo.text = [NSString stringWithFormat:@"%d",_matchPeople.age];
    }else{
        _userInfo.text = [NSString stringWithFormat:@"%@  •  %d",schoolName,_matchPeople.age];
    }
    
    if (_matchPeople.distance < 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%lum", (long)_matchPeople.distance];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", _matchPeople.distance/1000.0];
    }
    //    self.labelMatchScore.text = [NSString stringWithFormat:@"%lu%%", (long)mine.matchScore];
    //    NSInteger time = ([NSDate currentTimeMillis]-mine.actyTime)/1000/60;
    //    //NSLog(@"=====%lu", mine.matchScore)
    //    if (time<60) {
    //        self.labelActyTime.text = [NSString stringWithFormat:@"%lumin", (long)time];
    //    }else if (time>60 && time<60*24){
    //        self.labelActyTime.text = [NSString stringWithFormat:@"%ldh", time/60];
    //    }else{
    //        self.labelActyTime.text = [NSString stringWithFormat:@"%ld天", time/60/24];
    //    }
    //}
    self.timeLabel.text = [self getTime:_matchPeople.time];
    
}

- (NSString *)getTime:(NSInteger *)time{
    NSString *timeStr = @"";
    NSInteger timeZone = fabs((([NSDate currentTimeMillis] - _matchPeople.time)/1000/60));
    if (timeZone < 60) {
        timeStr = [NSString stringWithFormat:@"%lumin", (long)time];
    }else if (timeZone >60 && timeZone <60*24){
        timeStr = [NSString stringWithFormat:@"%dh", timeZone/60];
    }else{
        timeStr = [NSString stringWithFormat:@"%d天", timeZone/60/24];
    }
    return timeStr;
}

//获取学校
- (NSString *)searchSchoolNameWithID:(NSInteger)schoolID{
    DBSchools *dbSchools = [DBSchools shareInstance];
    return [[dbSchools schoolWithID:schoolID] objectForKey:@"schoolName"];
}

- (void)Circular{
    _headPortrait.layer.cornerRadius = _headPortrait.frame.size.width * 0.25 ;
    _headPortrait.clipsToBounds = YES;
}
@end
