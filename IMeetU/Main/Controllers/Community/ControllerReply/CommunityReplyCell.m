//
//  CommunityReplyCell.m
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CommunityReplyCell.h"
#import "YYKit/YYKit.h"
#import "NSDate+MJ.h"
#import "DBSchools.h"
#import "UIColor+Plug.h"
#import "UIFont+Plug.h"
#import "UserDefultAccount.h"


@interface CommunityReplyCell()
@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet YYLabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;


@end
@implementation CommunityReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModelComment:(ModelComment *)modelComment{
    _modelComment = modelComment;
    [_headImageView setImageWithURL:[NSURL URLWithString:_modelComment.userFromHead] placeholder:[UIImage imageNamed:@"photo_fail"]];
    _nickNameLabel.text = _modelComment.userFromName;
    _nickNameLabel.textColor = [_modelComment.userFromSex isEqualToString:@"1"] ? [UIColor often_8883BC:1] : [UIColor often_F06E7F:1];
    _collegeNameLabel.text = [self searchSchoolNameWithID:[_modelComment.userFromSchool integerValue]];
    //为回复
    NSString *str;
    if (modelComment.parentId != 0) {
        str = [NSString stringWithFormat:@"回复 %@:%@",_modelComment.userToName,_modelComment.content];
         NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        //进行范围设置
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value: [_modelComment.userFromSex isEqualToString:@"1"] ? [UIColor often_8883BC:1] : [UIColor often_F06E7F:1]
                        range:NSMakeRange(3, _modelComment.userFromName.length)];
        _contentLabel.attributedText = attrStr;
    }else{
        str = _modelComment.content;
        _contentLabel.text = _modelComment.content;
    }
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:str];
    contentText.font = [UIFont systemFontOfSize:13];
    contentText.lineSpacing = 2.6;
    _contentLabel.attributedText = contentText;
    CGFloat commentSizeHeight = [UIFont getSpaceLabelHeight:modelComment.content withFont:_contentLabel.font withWidth:(self.width - 63) withLineSpacing:2.6];
    self.contentLabelHeight.constant = ceil(commentSizeHeight);
    [self.contentLabel layoutIfNeeded];

//    CGFloat titleSizeHeight = [UIFont getSpaceLabelHeight:modelPost.content withFont:_contentLabel.font withWidth:(self.width - 20) withLineSpacing:2.6];
//    _commentLabelHeight.constant = ceil(titleSizeHeight);

}

- (NSString *)createdAt:(long long)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //2015-09-08 18:05:31
    fmt.dateFormat = @"yyyyMMddHHmmss";
    //#warning 真机调试的时候，必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 获得微博发布的具体时间
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:time];
    // 判断是否为今年
    if (createDate.isThisYear) {
        NSDateComponents *cmps = [createDate deltaWithNow];
        
        if (createDate.isToday) { // 今天
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:createDate];
        } else if (cmps.day == 1) { // 昨天
            fmt.dateFormat = @"HH:mm";
            return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:createDate]];
        } else if (cmps.day == 2){
            fmt.dateFormat = @"HH:mm";
            [NSString stringWithFormat:@"前天 %@",[fmt stringFromDate:createDate]];
        }
        fmt.dateFormat = @"MM-dd";
        return [fmt stringFromDate:createDate];
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }
    return nil;
}

- (NSString *)searchSchoolNameWithID:(NSInteger)schoolID{
    DBSchools *dbSchools = [DBSchools shareInstance];
    return [[dbSchools schoolWithID:schoolID] objectForKey:@"schoolName"];
}

//进行相关的操作
- (IBAction)operationBtnClick:(id)sender {
    if (self.replyOperationBlock) {
        _replyOperationBlock(_modelComment.commentId,_modelComment.userFromCode);
    }
}
- (IBAction)goHomePage:(id)sender {
    if (self.replyGotoHomePage) {
        _replyGotoHomePage(_modelComment.userFromCode);
    }
}

@end
