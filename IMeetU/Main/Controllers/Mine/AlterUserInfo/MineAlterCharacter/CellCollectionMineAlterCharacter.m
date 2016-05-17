//
//  CellCollectionMineAlertCharacter.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellCollectionMineAlterCharacter.h"

@interface CellCollectionMineAlterCharacter()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelCharacted;


@end
@implementation CellCollectionMineAlterCharacter

- (void)initWithCharacter:(NSString *)character selected:(BOOL)selected{
    [self.labelCharacted setText:character];
    if (selected) {
        [self.labelCharacted setTextColor:[UIColor whiteColor]];
        [self.imgViewStatus setImage:[UIImage imageNamed:@"mine_alter_character_interest_selected"]];
    }else{
        [self.labelCharacted setTextColor:[UIColor blackColor]];
        [self.imgViewStatus setImage:[UIImage imageNamed:@"mine_alter_character_interest"]];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

@end
