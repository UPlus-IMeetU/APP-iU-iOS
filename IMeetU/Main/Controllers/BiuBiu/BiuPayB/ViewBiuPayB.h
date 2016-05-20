//
//  ViewBiuPayB.h
//  IMeetU
//
//  Created by zhanghao on 16/4/5.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewBiuPayBDelegate;

@interface ViewBiuPayB : UIView

- (void)initWithViewHeight:(CGFloat)height;
- (void)initialWithUmiCount:(NSInteger)umiCount;

@property (nonatomic, weak) id<ViewBiuPayBDelegate> delegatePayUmi;

@end
@protocol ViewBiuPayBDelegate <NSObject>
@optional
- (void)viewBiuPayB:(UIView*)view payRes:(BOOL)res umiCount:(NSInteger)count;
- (void)buyUMi:(NSInteger) money;
@end