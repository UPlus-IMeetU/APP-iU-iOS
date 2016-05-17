//
//  ViewNewComerGuide.h
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewNewComerGuide : UIView

+ (instancetype)view;

- (void)showInView:(UIView*)superView completion:(void(^)(BOOL finished))completion;

@end
