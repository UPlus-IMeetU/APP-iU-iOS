//
//  CellBiuAccept.h
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelBiuAccept;
@protocol CellBiuAcceptDelegate;

@interface CellBiuAccept : UITableViewCell

@property (nonatomic, weak) id<CellBiuAcceptDelegate> delegateCellAccept;
- (void)initWithModel:(ModelBiuAccept*)model;

- (void)setAlreadyAccept;

@end
@protocol CellBiuAcceptDelegate <NSObject>
@optional
- (void)cellBiuAccept:(CellBiuAccept*)cell onClickBtnProfile:(ModelBiuAccept*)model;

- (void)cellBiuAccept:(CellBiuAccept*)cell onClickBtnAccept:(ModelBiuAccept*)model;

@end