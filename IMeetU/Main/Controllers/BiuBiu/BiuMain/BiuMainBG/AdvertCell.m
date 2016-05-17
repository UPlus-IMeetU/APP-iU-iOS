//
//  AdvertCell.m
//  IMeetU
//
//  Created by Spring on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "AdvertCell.h"
@interface AdvertCell()


@end
@implementation AdvertCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _advertImageView.layer.cornerRadius = 5;
    _advertImageView.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
