//
//  ViewMineMainAlterProfile.h
//  IMeetU
//
//  Created by zhanghao on 16/3/10.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewMineMainAlterProfileDelegate;

@interface ViewMineMainAlterProfile : UIView

@property (nonatomic, weak) id<ViewMineMainAlterProfileDelegate> delegateProfile;

+ (instancetype)viewMineMainAlterProfileWithIsMine:(BOOL)isMine;

- (void)showWithUrl:(NSString*)url superView:(UIView*)superView;

- (void)hiddenAndRemove;

@end
@protocol ViewMineMainAlterProfileDelegate <NSObject>
@optional
- (void)viewMineMainAlterProfileAfterReadingDialog:(ViewMineMainAlterProfile*)view;

- (void)viewMineMainAlterProfileClose:(ViewMineMainAlterProfile*)view;
@end