//
//  ReusableViewBiuReceiveFooterBiuB.h
//  IMeetU
//
//  Created by zhanghao on 16/3/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReusableViewBiuReceiveFooterBiuBDelegate;

@interface ReusableViewBiuReceiveFooterBiuB : UICollectionReusableView

@property (nonatomic, weak) id<ReusableViewBiuReceiveFooterBiuBDelegate> delegateFooter;

@end
@protocol ReusableViewBiuReceiveFooterBiuBDelegate <NSObject>
@optional
- (void)reusableViewBiuReceiveFooterBiuBSend:(ReusableViewBiuReceiveFooterBiuB*)reusableView;

- (void)reusableViewBiuReceiveFooterBiuBPay:(ReusableViewBiuReceiveFooterBiuB*)reusableView;

@end