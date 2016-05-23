//
//  XMBiuFaceStarCollection.h
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMBiuFaceStar.h"

@protocol XMBiuFaceStarCollectionDelegate;

@interface XMBiuFaceStarCollection : UIView

+ (instancetype)biuFaceStarCollectionWithSuperViewSize:(CGSize)superViewSize trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr;

@property (nonatomic, weak) id<XMBiuFaceStarCollectionDelegate> delegateFaceStarCollection;

- (void)refresh;

- (void)refreshWithModels:(NSArray*)models;

- (void)addNewFaceStarWithModel:(ModelBiuFaceStar*)model;

- (void)removeFaceStarWithModel:(ModelBiuFaceStar*)model;

- (void)superViewDidAppear:(BOOL)animated;

- (void)superViewDidDisappear:(BOOL)animated;

/**
 *  视图中头像的个数
 *
 *  @return 头像个数
 */
- (NSInteger)countOfFaceStar;
@end
@protocol XMBiuFaceStarCollectionDelegate <NSObject>
@optional
- (void)xmBiuFaceStarCollection:(XMBiuFaceStarCollection*)view onClickProfileWithModel:(ModelBiuFaceStar*)model;

@end