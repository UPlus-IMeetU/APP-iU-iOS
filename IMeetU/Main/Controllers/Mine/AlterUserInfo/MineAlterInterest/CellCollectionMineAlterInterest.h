//
//  CellCollectionMineAlterInterest.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelMineAlterInterest;

@interface CellCollectionMineAlterInterest : UICollectionViewCell

- (void)initWithModelInterest:(ModelMineAlterInterest*)model sectionTitle:(NSString*)sectionTitle;

@end
