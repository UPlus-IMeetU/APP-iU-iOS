//
//  CellMineMainCollectionTag.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMineMainCollectionTag.h"

#import "ModelCharacher.h"
#import "ModelMineAlterInterest.h"

@interface CellMineMainCollectionTag()

@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBg;

@end
@implementation CellMineMainCollectionTag

- (void)initWithCharacter:(ModelCharacher *)character{
    [self.imgViewBg setImage:[UIImage imageNamed:@"mine_alter_character_interest_selected"]];
    [self.labelContent setText:character.content];
}

- (void)initWithInterest:(ModelMineAlterInterest *)interest{
    [self.imgViewBg setImage:interest.bgNameSelected];
    [self.labelContent setText:interest.interestContent];
}

@end
