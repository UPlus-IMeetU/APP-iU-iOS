//
//  ZXCycleScrollView.h
//  广告循环滚动
//
//  Created by power on 15/8/25.
//  Copyright (c) 2015年 power. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXCycleScrollViewDelegate;
@protocol ZXCycleScrollViewDatasource;

@interface ZXCycleScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPages;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,strong) NSMutableArray *curViews;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign,setter = setDataource:) id<ZXCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<ZXCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

// 改变pageControl的颜色
- (void)changePageControlColor:(UIColor*)currentColor :(UIColor*)indicatopColor;

@end
//=======================================
@protocol ZXCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(ZXCycleScrollView *)csView atIndex:(NSInteger)index;
@end
//===========================================
@protocol ZXCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end

