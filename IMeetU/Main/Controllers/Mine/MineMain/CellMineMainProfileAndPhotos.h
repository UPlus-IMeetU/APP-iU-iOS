//
//  CellMineMainProfileAndPhotos.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelResponseMine;

@protocol CellMineMainProfileAndPhotosDelegate;

@interface CellMineMainProfileAndPhotos : UITableViewCell

@property (nonatomic, weak) id<CellMineMainProfileAndPhotosDelegate> delegateCell;
- (void)initWithMine:(ModelResponseMine*)mine isMine:(BOOL)isMine isShowBtnBack:(BOOL)isShowBtnBack;

+ (CGFloat)viewHeight;
+ (CGFloat)viewHeaderHeight;

@end
@protocol CellMineMainProfileAndPhotosDelegate <NSObject>
@optional

- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos*)cell onClickBtnProfile:(UIButton*)btn;

- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos*)cell onClickBtnBack:(UIButton*)btn;

- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos*)cell onClickBtnUserIdentifier:(UIButton*)btn;

- (void)cellMineMainProfileAndPhotosAddPhotos:(CellMineMainProfileAndPhotos*)cell;

- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos*)cell photoIndexPath:(NSIndexPath*)indexPath;

- (void)cellMineMainProfileAndPhotosOnClickMore:(CellMineMainProfileAndPhotos*)cell;

//进入U币充值中心
- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos*)cell onClickBuyUMi:(UIButton*)btn;

//进入匹配页面
- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos *)cell onClickSetting:(UIButton *)btn;

@end
