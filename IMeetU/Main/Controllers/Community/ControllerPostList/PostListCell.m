//
//  PostListCell.m
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "PostListCell.h"
#import "NSDate+MJ.h"
#import "ModelTag.h"
#import "ModelImage.h"

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


- (void)setModelPost:(ModelPost *)modelPost{
    _modelPost = modelPost;
    //进行清理
     [_praiseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_photoView removeAllSubviews];
    //进行cell的赋值
    [_headPortraitImage setImageWithURL:[NSURL URLWithString:modelPost.userHead] placeholder:[UIImage imageNamed:@"photo_fail"]];
    _nickNameLabel.text = _modelPost.userName;
    _timeLabel.text = [self createdAt:_modelPost.creatAt];
    ModelTag *modelTag = _modelPost.tags[0];
    _tagsLabel.text = [NSString stringWithFormat:@"#%@#",modelTag.content];
    _contentLabel.text = _modelPost.content;
    _praiseLabel.text = (_modelPost.praiseNum) == 0 ? @"":[NSString stringWithFormat:@"赞%ld",(long)_modelPost.praiseNum];
    _commentLabel.text = (_modelPost.commentNum) == 0 ? @"":[NSString stringWithFormat:@"评论%ld",(long)_modelPost.commentNum];
    NSString *contentStr = modelPost.content;
    CGSize titleSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(self.width - 20, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    _commentLabelHeight.constant = ceil(titleSize.height);
    if (_modelPost.isPraise) {
        [_praiseBtn setImage:[UIImage imageNamed:@"found_btn_like_light"] forState:UIControlStateNormal];
    }else{
        [_praiseBtn setImage:[UIImage imageNamed:@"found_btn_like_normal"] forState:UIControlStateNormal];
    }
    
    
    //进行图片的排版布局
    NSInteger imageCount = _modelPost.imgs.count;
    NSInteger photoWidth = 0;
    if (imageCount == 0) {
        _photoViewHeight.constant = -20;
    }else if(imageCount == 1){
        _photoViewHeight.constant = self.width - 20;
        photoWidth = self.width - 20;
    }else if(imageCount == 2){
        _photoViewHeight.constant = (self.width - 20 - 5) * 0.5;
        photoWidth = (self.width - 20 - 5) * 0.5;
    }else if(imageCount == 3){
        _photoViewHeight.constant = ceil((self.width - 20 - 5 * 2) /  3);
        photoWidth = (self.width - 20 - 5 * 2) / 3;
    }else if(imageCount >3 && imageCount <= 6){
        _photoViewHeight.constant = ceil((self.width - 20 - 5 * 2) /  3) * 2 + 5;
         photoWidth = (self.width - 20 - 5 * 2) / 3;
    }else{
        _photoViewHeight.constant = ceil((self.width - 20 - 5 * 2) /  3) * 3 + 5 * 2;
         photoWidth = (self.width - 20 - 5 * 2) / 3;
    }
    
    
    //进行页面的布局
    for (int index = 0; index < imageCount; index ++) {
        NSInteger column = index % 3;
        NSInteger  line = index / 3;
        NSInteger x = (photoWidth + 5) * column;
        NSInteger y = (photoWidth + 5) * line;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, photoWidth, photoWidth)];
        //放开权限
        ModelImage *modelImage = _modelPost.imgs[index];
        [imageView setImageWithURL:[NSURL URLWithString:modelImage.imageUrl] placeholder:[UIImage imageNamed:@"global_photo_load_fail"]];
        imageView.userInteractionEnabled = YES;
        [self.photoView addSubview:imageView];
    }
    
    [self.photoView layoutIfNeeded];
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

- (IBAction)operationBtnClick:(id)sender {
    if (self.postViewOperationBlock) {
        self.postViewOperationBlock(_modelPost.postId,OperationTypeDelete);
    }
}


- (IBAction)praiseBtnClick:(id)sender {
    if (self.postViewPraiseBlock) {
        self.postViewPraiseBlock(_modelPost.postId,_modelPost.isPraise);
    }
}


- (void)tagsClick:(UIGestureRecognizer *)gesture{
    NSLog(@"进入对应标签的列表");
}
@end
