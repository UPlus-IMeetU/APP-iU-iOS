//
//  XMBiuFaceStar.h
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelBiuFaceStar;
@protocol XMBiuFaceStarDelegate;

@interface XMBiuFaceStar : UIView

@property (nonatomic, assign) CGFloat positionAngle;
@property (nonatomic, assign) CGFloat positionX;
@property (nonatomic, assign) CGFloat positionY;
@property (nonatomic, assign) NSInteger birthday;

@property (nonatomic, weak) id<XMBiuFaceStarDelegate> delegateFaceStar;

+ (instancetype)biuFaceStarWithModel:(ModelBiuFaceStar*)model trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr circleCenter:(CGPoint)circleCenter collectionFaceStarInside:(NSArray *)collectionFaceStarInside;

+ (instancetype)biuFaceStarWithTrajectoryIndex:(NSInteger)index model:(ModelBiuFaceStar*)model trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr circleCenter:(CGPoint)circleCenter collectionFaceStar:(NSArray *)collectionFaceStar;

- (ModelBiuFaceStar*)getModel;

- (BOOL)isEqualWithUserCode:(NSString*)userCode;

- (void)showNormalFaceStarWithSuperView:(UIView*)superView;

- (void)showFaceStarWithSuperView:(UIView*)superView;

- (BOOL)transferToNextTrajectoryWithTargetCollectionFaceStar:(NSArray *)collectionFaceStar;

- (void)hiddenAndDestroy;

@end
@protocol XMBiuFaceStarDelegate <NSObject>
@optional
- (void)xmBiuFaceStar:(XMBiuFaceStar*)view onClickProfileWithModel:(ModelBiuFaceStar*)model;

@end