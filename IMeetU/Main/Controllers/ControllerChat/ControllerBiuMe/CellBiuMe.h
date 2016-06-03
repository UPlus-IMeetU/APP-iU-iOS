//
//  CellBiuMe.h
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelBiuMe;
@protocol CellBiuMeDelegate;

@interface CellBiuMe : UITableViewCell

@property (nonatomic, weak) id<CellBiuMeDelegate> delegateBiuMe;
- (void)initWithModel:(ModelBiuMe*)model;

@end
@protocol CellBiuMeDelegate <NSObject>
@optional
- (void)cell:(CellBiuMe*)cell onClickBtnProfile:(ModelBiuMe*)model;

- (void)cell:(CellBiuMe*)cell onClickBtnAccept:(ModelBiuMe*)model;

@end