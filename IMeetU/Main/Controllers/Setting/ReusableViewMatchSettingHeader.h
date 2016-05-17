//
//  ReusableViewMatchSettingHeader.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelMatchSetting;

@protocol ReusableViewMatchSettingHeaderDelegate;

@interface ReusableViewMatchSettingHeader : UICollectionReusableView

@property (nonatomic, weak) id<ReusableViewMatchSettingHeaderDelegate> delegateReusableView;
- (void)initWithModel:(ModelMatchSetting*)model;

@end
@protocol ReusableViewMatchSettingHeaderDelegate <NSObject>
@optional
- (void)reusableViewMatchSettingHeaderAlterCharacter:(ReusableViewMatchSettingHeader*)view;

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader*)reusableView alterGender:(NSInteger)gender;

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader*)reusableView alterAreaRange:(NSInteger)areaRange;

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader*)reusableView alterAgeCeiling:(NSInteger)ageCeiling;

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader*)reusableView alterAgeFloor:(NSInteger)ageFloor;


@end
