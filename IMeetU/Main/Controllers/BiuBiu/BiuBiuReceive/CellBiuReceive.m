//
//  CellBiuReceive.m
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellBiuReceive.h"

@interface CellBiuReceive()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBg;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end
@implementation CellBiuReceive

- (void)initWithCharacter:(ModelCharacher *)model{
    self.labelContent.text = model.content;
    self.imgViewBg.image = [UIImage imageNamed:@"mine_main_imageview_tag_bg"];
}

- (void)initWithInterest:(ModelMineAlterInterest *)model{
    self.labelContent.text = model.interestContent;
    self.imgViewBg.image = [model bgNameSelected];
}

@end
