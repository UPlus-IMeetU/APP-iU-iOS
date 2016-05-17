//
//  CellEmoji.m
//  MeetU
//
//  Created by zhanghao on 15/9/27.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "CellEmoji.h"

#import "Masonry.h"

@interface CellEmoji()

@property (nonatomic, strong) UIImageView *emoji;

@end
@implementation CellEmoji

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.emoji = [[UIImageView alloc] init];
        [self addSubview:self.emoji];
        
        [self.emoji mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    [self.emoji setImage:image];
}

@end
