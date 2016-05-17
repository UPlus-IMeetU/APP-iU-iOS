//
//  CellBiuContact.h
//  IMeetU
//
//  Created by zhanghao on 16/3/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelContact;

@protocol CellBiuContactDelegate;

@interface CellBiuContact : UITableViewCell

@property (nonatomic, weak) id<CellBiuContactDelegate> delegateCell;
- (void)initWithModel:(ModelContact*)model;

@end
@protocol CellBiuContactDelegate <NSObject>
@optional
- (void)cellBiuContact:(CellBiuContact*)cell onClickProfile:(ModelContact*)contact;

@end