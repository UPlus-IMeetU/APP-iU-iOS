//
//  ReusableViewMatchSettingFooter.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelMatchSetting;
@protocol ReusableViewMatchSettingFooterDelegate;

@interface ReusableViewMatchSettingFooter : UICollectionReusableView

@property (nonatomic, weak) id<ReusableViewMatchSettingFooterDelegate> delegateMatchSetting;
- (void)initWithModel:(ModelMatchSetting*)model;

@end
@protocol ReusableViewMatchSettingFooterDelegate <NSObject>
@optional
- (void)reusableViewMatchSettingFooter:(ReusableViewMatchSettingFooter*)reusableView switchRes:(ModelMatchSetting*)switchRes;

- (void)reusableViewMatchSettingFooter:(ReusableViewMatchSettingFooter*)reusableView onLogout:(UIButton*)btnLogout;

- (void)reusableViewMatchSettingFooter:(ReusableViewMatchSettingFooter *)reusableView setBtnClick:(UIButton *)btn;

@end