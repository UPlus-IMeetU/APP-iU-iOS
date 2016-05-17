//
//  CellCollectionMatchSettingCharacter.m
//  IMeetU
//
//  Created by zhanghao on 16/3/10.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellCollectionMatchSettingCharacter.h"
#import "ModelCharacher.h"

@interface CellCollectionMatchSettingCharacter()

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end
@implementation CellCollectionMatchSettingCharacter

- (void)initWithModel:(ModelCharacher*)model{
    [self.labelContent setText:model.content];
}

@end
