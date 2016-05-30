//
//  PostListCell.m
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "PostListCell.h"
#import <YYKit/YYKit.h>
@interface PostListCell()
/**
 *  头像视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *headPortraitImage;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
/**
 *  大学名称
 */
@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;
/**
 *  权限操作
 */
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  相册
 */
@property (weak, nonatomic) IBOutlet UIView *photoView;
/**
 *  标签
 */
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
/**
 *  详细的内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  点赞的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
/**
 *  评论的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
/**
 *  点赞按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
/**
 *  评论按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/**
 *  图片视图的高度 根据图片的个数对应的高度也有相应的变化
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
/**
 *  内容的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelHeight;

@end
@implementation PostListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tagsGesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagsClick:)];
    self.tagsLabel.userInteractionEnabled = YES;
    [self.tagsLabel addGestureRecognizer:tagsGesutre];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)operationBtnClick:(id)sender {
    NSLog(@"点击操作按钮");
}


- (IBAction)praiseBtnClick:(id)sender {
    NSLog(@"点击点赞按钮");
}


- (void)tagsClick:(UIGestureRecognizer *)gesture{
    NSLog(@"进入对应标签的列表");
}
@end
