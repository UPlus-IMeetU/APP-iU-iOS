//
//  CatTabBar.h
//  Catweibo
//
//  Created by Justin on 15/4/2.
//  Copyright (c) 2015年 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatTabBar;

@protocol CatTabBarDelegate <NSObject>

@optional
- (void)tabbar:(CatTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

@end

@interface CatTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic,weak) id<CatTabBarDelegate> delegate;



@end
