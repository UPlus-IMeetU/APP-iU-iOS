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

@interface CommunityReplyCell()
@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
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
    _nickNameLabel.text = [_modelComment.userToName isEqualToString:@""] ? _modelComment.userFromName : [NSString stringWithFormat:@"%@回复:%@",_modelComment.userFromName,_modelComment.userToName];
    _timeLabel.text = [self createdAt:_modelComment.createAt];
    _contentLabel.text = modelComment.content;

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

//进行相关的操作
- (IBAction)operationBtnClick:(id)sender {
    if (self.replyOperationBlock) {
        _replyOperationBlock(_modelComment.commentId,1);
    }
}

@end
