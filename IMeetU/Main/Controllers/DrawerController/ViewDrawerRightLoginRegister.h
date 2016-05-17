//
//  ViewDrawerRightLoginRegister.h
//  IMeetU
//
//  Created by zhanghao on 16/5/13.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewDrawerRightLoginRegisterDelegate;

@interface ViewDrawerRightLoginRegister : UIView

@property (nonatomic, weak) id<ViewDrawerRightLoginRegisterDelegate> delegateLoginRegister;
+ (instancetype)view;

@end
@protocol ViewDrawerRightLoginRegisterDelegate <NSObject>
@optional
- (void)viewDrawerRightRegister:(ViewDrawerRightLoginRegister*)view;
- (void)viewDrawerRightLogin:(ViewDrawerRightLoginRegister*)view;

@end
