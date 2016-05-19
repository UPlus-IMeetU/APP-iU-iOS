//
//  MLCollectionViewWaterfallLayout.h
//  MeetU
//
//  Created by zhanghao on 15/8/29.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLCollectionViewWaterfallLayoutDelegate;

@interface MLCollectionViewWaterfallLayout : UICollectionViewLayout

@property (nonatomic, strong) id<MLCollectionViewWaterfallLayoutDelegate> delegateLayout;
//行间距
@property (nonatomic, assign) CGFloat rowMargin;
//列间距
@property (nonatomic, assign) CGFloat columnMargin;
//边缘间距
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
//变化的内容距Cell的边距
@property (nonatomic, assign) UIEdgeInsets cellInsets;
//列的数量
@property (nonatomic, assign) int columnCount;

@end
@protocol MLCollectionViewWaterfallLayoutDelegate <NSObject>
@optional
- (CGSize)cellContentSizeWithIndexPath:(NSIndexPath*)indexPath;

- (void)cellFrame:(CGRect)frame indexPath:(NSIndexPath*)indexPath;

@end