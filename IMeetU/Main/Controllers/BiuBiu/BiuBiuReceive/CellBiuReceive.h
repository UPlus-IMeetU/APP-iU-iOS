//
//  CellBiuReceive.h
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelCharacher.h"
#import "ModelMineAlterInterest.h"

@interface CellBiuReceive : UICollectionViewCell

- (void)initWithCharacter:(ModelCharacher*)model;

- (void)initWithInterest:(ModelMineAlterInterest*)model;

@end
