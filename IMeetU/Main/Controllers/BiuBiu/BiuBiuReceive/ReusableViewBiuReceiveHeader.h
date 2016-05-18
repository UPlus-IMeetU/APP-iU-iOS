//
//  ReusableViewBiuReceiveHeader.h
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelBiuReceive.h"

@protocol ReusableViewBiuReceiveHeaderDelegate;

@interface ReusableViewBiuReceiveHeader : UICollectionReusableView

@property (nonatomic, weak) id<ReusableViewBiuReceiveHeaderDelegate> delegateReusableView;
- (void)initWithModel:(ModelBiuReceive*)model;

@end
@protocol ReusableViewBiuReceiveHeaderDelegate <NSObject>
@optional
- (void)reusableViewBiuReceiveHeader:(ReusableViewBiuReceiveHeader*)reusableView profileUrl:(NSString*)url;

- (void)reusableViewBiuReceiveHeader:(ReusableViewBiuReceiveHeader*)reusableView onClickBtnUserIdentifier:(UIButton*)btn;

- (void)resuableViewBiuReceiveHeader:(ReusableViewBiuReceiveHeader*)reusableView
    onClickDropDown:(UIButton *)btn;
@end