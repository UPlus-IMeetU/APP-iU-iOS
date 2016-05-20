//
//  ReusableViewBiuReceiveFooter.h
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReusableViewBiuReceiveFooterDelegate;

@interface ReusableViewBiuReceiveFooter : UICollectionReusableView

@property (nonatomic, weak) id<ReusableViewBiuReceiveFooterDelegate> delegateFooter;
- (void)initWithMessage:(NSInteger)message;


@end
@protocol ReusableViewBiuReceiveFooterDelegate <NSObject>
@optional
- (void)reusableViewBiuReceiveFooterGrabBiu:(ReusableViewBiuReceiveFooter*)reusableView WithButton:(UIButton *)button;

- (void)reusableViewBiuReceiveFooterUnreceiveTA:(ReusableViewBiuReceiveFooter*)reusableView;

@end