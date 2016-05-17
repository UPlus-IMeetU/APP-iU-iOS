//
//  CellMineMainCollectionTag.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelCharacher;
@class ModelMineAlterInterest;

@interface CellMineMainCollectionTag : UICollectionViewCell

- (void)initWithCharacter:(ModelCharacher *)character;
- (void)initWithInterest:(ModelMineAlterInterest *)interest;

@end
