//
//  CommunityReplyCell.m
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CommunityReplyCell.h"
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
//进行相关的操作
- (IBAction)operationBtnClickc:(id)sender {
    if (self.replyOperationBlock) {
        _replyOperationBlock(_modelPostDetail.postId,OperationTypeDelete);
    }
}

@end
