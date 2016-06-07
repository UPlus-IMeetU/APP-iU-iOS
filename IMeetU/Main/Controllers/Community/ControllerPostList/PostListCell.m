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
#import "MJPhotoBrowser.h"
#import "DBSchools.h"
#import "UIColor+Plug.h"
#import "UserDefultAccount.h"
#import "UIFont+Plug.h"
#import "MWPhotoBrowser.h"
#import <CoreText/CoreText.h>
#import "UIImage+Plug.h"
#import "UIView+Plug.h"
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
 *  评论的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
/**
 *  点赞按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
/**
 *  详细的内容
 */
@property (weak, nonatomic) IBOutlet YYLabel *contentLabel;
/**
 *  点赞的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departHeight;

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
    _departHeight.constant = 20;
    
    //进行清理
    [_praiseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_photoView removeAllSubviews];
    //进行cell的赋值
    [_headPortraitImage setImageWithURL:[NSURL URLWithString:modelPost.userHead] placeholder:[UIImage imageNamed:@"photo_fail"]];
    _nickNameLabel.text = _modelPost.userName;
    _nickNameLabel.textColor = [_modelPost.userSex isEqualToString:@"1"] ? [UIColor often_8883BC:1] : [UIColor often_F06E7F:1];
    _timeLabel.text = [self createdAt:_modelPost.createAt];
    if (_modelPost.tags.count == 0) {
        _tagsLabel.text = @"";
    }else{
        ModelTag *modelTag = _modelPost.tags[0];
        _tagsLabel.text = [NSString stringWithFormat:@"#%@#",modelTag.content];
        _tagsLabel.tag = modelTag.tagId + 10000;
    }
    
    //进行相应的修改
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:_modelPost.content];
    contentText.font = [UIFont systemFontOfSize:13];
    contentText.lineSpacing = 2.6;
    
    CGFloat titleSizeHeight = [UIFont getSpaceLabelHeight:modelPost.content withFont:_contentLabel.font withWidth:(self.width - 20) withLineSpacing:2.6];
    _commentLabelHeight.constant = ceil(titleSizeHeight);
    _contentLabel.attributedText= contentText;
    _collegeNameLabel.text = [self searchSchoolNameWithID:[_modelPost.userSchool integerValue]];
    if (!_collegeNameLabel.text) {
        _collegeNameLabel.text = @"   ";
    }
    _praiseLabel.text = [NSString stringWithFormat:@"赞 %ld",(long)_modelPost.praiseNum];
    _commentLabel.text = [NSString stringWithFormat:@"评论 %ld",(long)_modelPost.commentNum];
    if (_modelPost.isPraise) {
        [_praiseBtn setImage:[[UIImage imageNamed:@"found_btn_like_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [_praiseBtn setImage:[[UIImage imageNamed:@"found_btn_like_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
   
    
    
    //进行图片的排版布局
    NSInteger imageCount = _modelPost.imgs.count;
    NSInteger photoWidth = 0;
    if (imageCount == 0 ) {
        _departHeight.constant = 0;
        _photoViewHeight.constant = 0;
    }else if(imageCount == 1){
        _photoViewHeight.constant = self.width - 20;
        photoWidth = self.width - 20;
    }else if(imageCount == 2){
        _photoViewHeight.constant = (self.width - 20 - 5) * 0.5;
        photoWidth = (self.width - 20 - 5) * 0.5;
    }else if(imageCount == 3){
        _photoViewHeight.constant = ceil((self.width - 20 - 5 * 2) /  3);
        photoWidth = (self.width - 20 - 5 * 2) / 3;
    }
    else if(imageCount >3 && imageCount <= 6){
        _photoViewHeight.constant = ceil((self.width - 20 - 5 * 2) /  3) * 2 + 5;
        photoWidth = (self.width - 20 - 5 * 2) / 3;
    }else{
        _photoViewHeight.constant = ceil((self.width - 20 - 5 * 2) /  3) * 3 + 5 * 2;
        photoWidth = (self.width - 20 - 5 * 2) / 3;
    }
    
    
    //进行页面的布局
    //特殊布局
    NSInteger number = 3;
    if (imageCount == 4) {
        number = 2;
    }
    for (int index = 0; index < imageCount; index ++) {
        NSInteger column = index % number;
        NSInteger  line = index / number;
        NSInteger x = (photoWidth + 5) * column;
        NSInteger y = (photoWidth + 5) * line;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, photoWidth, photoWidth)];
        //放开权限
        ModelImage *modelImage = _modelPost.imgs[index];
        imageView.tag = index;
        
        //对数据进行处理
        NSString *newStr = [NSString stringWithFormat:@"%@@%ldh_%ldw_1e_1c_0o",modelImage.imageUrl,(long)photoWidth,(long)photoWidth];
        [imageView setImageWithURL:[NSURL URLWithString:newStr] placeholder:[UIImage imageNamed:@"global_photo_load_fail"]];
        imageView.image = [imageView.image rotateImageToOrientationUp];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        //imageView.image.imageOrientation = UIImageOrientationUp;
        [self.photoView addSubview:imageView];
    }
    
    [self.photoView layoutIfNeeded];
}



#pragma mark 进入对应的页面
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = (int)_modelPost.imgs.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        ModelImage *modelImage = _modelPost.imgs[i];
        NSString *url = [NSString stringWithFormat:@"%@@_0o",modelImage.imageUrl];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.photoView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.showSaveBtn = YES;
    [browser show];
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
        if (createDate.isToday) { // 今天
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:createDate];
        } else if (createDate.isYesterday) { // 昨天
            fmt.dateFormat = @"HH:mm";
            return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:createDate]];
        } else if ([[createDate dateByAddingDays:2] isToday]){
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

- (IBAction)operationBtnClick:(id)sender {
    if (self.postViewOperationBlock) {
        //进行判断，如果userCode和自己的userCode一致，就可以进行删除，不一致进行举报操作
        if (_modelPost.userCode != [[UserDefultAccount userCode] integerValue]) {
            self.postViewOperationBlock(_modelPost.postId,OperationTypeReport,_modelPost.userCode);
        }else{
            self.postViewOperationBlock(_modelPost.postId,OperationTypeDelete,_modelPost.userCode);
        }
    }
}


- (IBAction)praiseBtnClick:(UIButton *)sender {
    if (self.postViewPraiseBlock) {
        [_praiseBtn startDuangAnimation];
        self.postViewPraiseBlock(_modelPost.postId,_modelPost.userCode,_modelPost.isPraise);
    }
}


- (void)tagsClick:(UIGestureRecognizer *)gesture{
    if (self.postViewGoSameTagListBlock) {
        ModelTag *modelTag = _modelPost.tags[0];
        self.postViewGoSameTagListBlock(modelTag);
    }
}
- (IBAction)goHomePage:(id)sender {
    if (self.postViewGoHomePageBlock) {
        self.postViewGoHomePageBlock(_modelPost.userCode);
    }
}
- (IBAction)createComment:(id)sender {
    if (self.postViewCreateCommentBlock) {
        self.postViewCreateCommentBlock(_modelPost.postId);
    }
}
@end
