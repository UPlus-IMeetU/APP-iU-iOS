//
//  CellDrawerLeft.m
//  IMeetU
//
//  Created by zhanghao on 16/3/6.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellDrawerLeft.h"

#import "UIColor+Plug.h"
@interface CellDrawerLeft()

@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, copy) UIImage *cellImgIcon;
@property (nonatomic, copy) UIImage *cellImgIconLight;
@property (nonatomic, copy) UIImage *cellImgArrow;
@property (nonatomic, copy) UIImage *cellImgArrowLight;

@property (nonatomic, assign) BOOL isHiddenArrow;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;

@end
@implementation CellDrawerLeft

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initWithIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0) {
        self.cellTitle = @"biubiu";
        self.cellImgIcon = [UIImage imageNamed:@"drawer_left_biubiu"];
        self.cellImgIconLight = [UIImage imageNamed:@"drawer_left_biubiu_light"];
        self.isHiddenArrow = YES;
    }else if (indexPath.row == 1){
        self.cellTitle = @"消息";
        self.cellImgIcon = [UIImage imageNamed:@"drawer_left_msg"];
        self.cellImgIconLight = [UIImage imageNamed:@"drawer_left_msg_light"];
        self.isHiddenArrow = YES;
    }else if (indexPath.row == 2){
        self.cellTitle = @"匹配设置";
        self.cellImgIcon = [UIImage imageNamed:@"drawer_left_match_setting"];
        self.cellImgIconLight = [UIImage imageNamed:@"drawer_left_match_setting_light"];
        self.isHiddenArrow = NO;
    }else if (indexPath.row == 3){
        self.cellTitle = @"新手引导";
        self.cellImgIcon = [UIImage imageNamed:@"drawer_left_new_guide"];
        self.cellImgIconLight = [UIImage imageNamed:@"drawer_left_new_guide_light"];
        self.isHiddenArrow = NO;
    }else if (indexPath.row == 4){
        self.cellTitle = @"分享给好友";
        self.cellImgIcon = [UIImage imageNamed:@"drawer_left_share"];
        self.cellImgIconLight = [UIImage imageNamed:@"drawer_left_share_light"];
        self.isHiddenArrow = YES;
    }
    
    self.cellImgArrow = [UIImage imageNamed:@"drawer_left_skip_arrow"];
    self.cellImgArrowLight = [UIImage imageNamed:@"drawer_left_skip_arrow_light"];
    
    [self.imageViewIcon setImage:self.cellImgIcon];
    [self.imageViewArrow setHighlighted:self.isHiddenArrow];
    [self.labelTitle setText:self.cellTitle];
    [self.imageViewArrow setHidden:self.isHiddenArrow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.imageViewIcon setImage:self.cellImgIconLight];
        [self.imageViewArrow setImage:self.cellImgArrowLight];
        [self.labelTitle setTextColor:[UIColor colorWithR:106 G:201 B:193]];
        [self setBackgroundColor:[UIColor colorWithR:192 G:192 B:192]];
    }else{
        [self.imageViewIcon setImage:self.cellImgIcon];
        [self.imageViewArrow setImage:self.cellImgArrow];
        [self.labelTitle setTextColor:[UIColor colorWithR:86 G:86 B:86]];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
