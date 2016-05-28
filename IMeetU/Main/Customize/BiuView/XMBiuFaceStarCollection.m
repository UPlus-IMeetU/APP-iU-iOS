//
//  XMBiuFaceStarCollection.m
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMBiuFaceStarCollection.h"
#import "NSDate+plug.h"
#import "ModelBiuFaceStar.h"
#import "NSDate+plug.h"
#import <YYKit/YYKit.h>

@interface XMBiuFaceStarCollection()<XMBiuFaceStarDelegate>

@property (nonatomic, assign) CGSize superViewSize;
@property (nonatomic, assign) CGPoint circleCenter;
@property (nonatomic, assign) CGFloat circleCenterX;
@property (nonatomic, assign) CGFloat circleCenterY;
@property (nonatomic, strong) NSArray *trajectoryRadiusArr;

@property (nonatomic, assign) NSInteger collectionMaxTimeInside;
@property (nonatomic, assign) NSInteger collectionMaxTimeCenter;
@property (nonatomic, assign) NSInteger collectionMaxTimeOutside;

@property (nonatomic, assign) NSInteger collectionMaxCountInside;
@property (nonatomic, assign) NSInteger collectionMaxCountCenter;
@property (nonatomic, assign) NSInteger collectionMaxCountOutside;

@property (nonatomic, strong) NSMutableArray *collectionArrInside;
@property (nonatomic, strong) NSMutableArray *collectionArrCenter;
@property (nonatomic, strong) NSMutableArray *collectionArrOutside;

@property (nonatomic, strong) NSTimer *timerCleanFaceStar;

@end
@implementation XMBiuFaceStarCollection

+ (instancetype)biuFaceStarCollectionWithSuperViewSize:(CGSize)superViewSize trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr{
    XMBiuFaceStarCollection *biuFaceStarCollection = [[XMBiuFaceStarCollection alloc] init];
    [biuFaceStarCollection initialWithSuperViewSize:superViewSize trajectoryRadiusArr:trajectoryRadiusArr];
    
    return biuFaceStarCollection;
}

- (void)initialWithSuperViewSize:(CGSize)superViewSize trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr{
    self.superViewSize = superViewSize;
    self.trajectoryRadiusArr = trajectoryRadiusArr;
}

- (void)layoutSubviews{
    self.frame = CGRectMake(0, 0, self.superViewSize.width, self.superViewSize.height);
}

- (void)superViewDidAppear:(BOOL)animated{
//    self.timerCleanFaceStar = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onCleanFaceStar:) userInfo:nil repeats:YES];
}

- (void)superViewDidDisappear:(BOOL)animated{
//    [self.timerCleanFaceStar invalidate];
//    self.timerCleanFaceStar = nil;
}

- (void)refresh{
    NSMutableArray *models = [NSMutableArray array];
    for (XMBiuFaceStar *star in self.collectionArrInside) {
        ModelBiuFaceStar *model = [star getModel];
        model.matchTime = [NSDate currentTimeMillis];
        [models addObject:model];
    }
    for (XMBiuFaceStar *star in self.collectionArrCenter) {
        ModelBiuFaceStar *model = [star getModel];
        model.matchTime = [NSDate currentTimeMillis];
        [models addObject:model];
    }
    for (XMBiuFaceStar *star in self.collectionArrOutside) {
        ModelBiuFaceStar *model = [star getModel];
        model.matchTime = [NSDate currentTimeMillis];
        [models addObject:model];
    }
    
    [self refreshWithModels:models];
}

- (void)refreshWithModels:(NSArray *)models {
    //清空头像
    [self.collectionArrInside removeAllObjects];
    [self.collectionArrCenter removeAllObjects];
    [self.collectionArrOutside removeAllObjects];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    //添加头像
    NSInteger index = 0;
    ModelBiuFaceStar *faceStarModel;
    //添加最内层头像
    for (int i=0; i<self.collectionMaxCountInside; i++) {
        if (index>=models.count) {
            break;
        }
        faceStarModel = models[index];
        if (faceStarModel.matchTime/1000+self.collectionMaxTimeInside > [NSDate currentTimeMillisSecond]) {
            XMBiuFaceStar *faceStar = [XMBiuFaceStar biuFaceStarWithTrajectoryIndex:0 model:faceStarModel trajectoryRadiusArr:self.trajectoryRadiusArr circleCenter:self.circleCenter collectionFaceStar:self.collectionArrInside];
            if (faceStar) {
                faceStar.delegateFaceStar = self;
                [self.collectionArrInside addObject:faceStar];
                [faceStar showNormalFaceStarWithSuperView:self];
            }
            index ++;
        }else{
            break;
        }
    }
    
    //添加中间层头像
    for (int i=0; i<self.collectionMaxCountCenter; i++) {
        if (index>=models.count) {
            break;
        }
        faceStarModel = models[index];
        if (faceStarModel.matchTime/1000+self.collectionMaxTimeCenter > [NSDate currentTimeMillisSecond]) {
            XMBiuFaceStar *faceStar = [XMBiuFaceStar biuFaceStarWithTrajectoryIndex:1 model:faceStarModel trajectoryRadiusArr:self.trajectoryRadiusArr circleCenter:self.circleCenter collectionFaceStar:self.collectionArrCenter];
            if (faceStar) {
                faceStar.delegateFaceStar = self;
                [self.collectionArrCenter addObject:faceStar];
                [faceStar showNormalFaceStarWithSuperView:self];
            }
            index ++;
        }else{
            break;
        }
    }
    
    //添加最外层头像
    for (int i=0; i<self.collectionMaxCountOutside; i++) {
        if (index>=models.count) {
            break;
        }
        faceStarModel = models[index];
        if (faceStarModel.matchTime/1000+self.collectionMaxTimeOutside > [NSDate currentTimeMillisSecond]) {
            XMBiuFaceStar *faceStar = [XMBiuFaceStar biuFaceStarWithTrajectoryIndex:2 model:faceStarModel trajectoryRadiusArr:self.trajectoryRadiusArr circleCenter:self.circleCenter collectionFaceStar:self.collectionArrOutside];
            if (faceStar) {
                faceStar.delegateFaceStar = self;
                [self.collectionArrOutside addObject:faceStar];
                [faceStar showNormalFaceStarWithSuperView:self];
            }
            index ++;
        }else{
            break;
        }
    }
}

- (void)addNewFaceStarWithModel:(ModelBiuFaceStar*)model{
    //过滤重复：如果屏幕上已经存在，抛弃
    for (XMBiuFaceStar *biu in self.collectionArrInside) {
        if ([biu isEqualWithUserCode:model.userCode]) {
            return;
        }
    }
    for (XMBiuFaceStar *biu in self.collectionArrCenter) {
        if ([biu isEqualWithUserCode:model.userCode]) {
            return;
        }
    }
    for (XMBiuFaceStar *biu in self.collectionArrOutside) {
        if ([biu isEqualWithUserCode:model.userCode]) {
            return;
        }
    }
    
    
    
    if (self.collectionArrOutside.count >= self.collectionMaxCountOutside) {
        XMBiuFaceStar *olderOutsideFaceStar = self.collectionArrOutside[0];
        [self.collectionArrOutside removeObjectAtIndex:0];
        [olderOutsideFaceStar hiddenAndDestroy];
    }
    
    if (self.collectionArrCenter.count >= self.collectionMaxCountCenter) {
        XMBiuFaceStar *olderCenterFaceStar = self.collectionArrCenter[0];
        [self.collectionArrCenter removeObjectAtIndex:0];
        BOOL resTransfer = [olderCenterFaceStar transferToNextTrajectoryWithTargetCollectionFaceStar:self.collectionArrOutside];
        if (resTransfer) {
            [self.collectionArrOutside addObject:olderCenterFaceStar];
        }
    }
    
    if (self.collectionArrInside.count >= self.collectionMaxCountInside) {
        XMBiuFaceStar *olderInsideFaceStar = self.collectionArrInside[0];
        [self.collectionArrInside removeObjectAtIndex:0];
        BOOL resTransfer = [olderInsideFaceStar transferToNextTrajectoryWithTargetCollectionFaceStar:self.collectionArrCenter];
        if (resTransfer) {
            [self.collectionArrCenter addObject:olderInsideFaceStar];
        }
    }
    
    
    XMBiuFaceStar *faceStar = [XMBiuFaceStar biuFaceStarWithModel:model trajectoryRadiusArr:self.trajectoryRadiusArr circleCenter:self.circleCenter collectionFaceStarInside:self.collectionArrInside];
    if (faceStar) {
        faceStar.delegateFaceStar = self;
        [self.collectionArrInside addObject:faceStar];
        [faceStar showFaceStarWithSuperView:self];
    }
}

- (void)removeFaceStarWithModel:(ModelBiuFaceStar *)model{
    for (XMBiuFaceStar *faceStar in self.collectionArrInside) {
        if ([faceStar isEqualWithUserCode:model.userCode]) {
            [self.collectionArrInside removeObject:faceStar];
            [UIView animateWithDuration:0.3 animations:^{
                faceStar.alpha = 0;
            } completion:^(BOOL finished) {
                [faceStar removeFromSuperview];
            }];
            
            return;
        }
    }
    
    for (XMBiuFaceStar *faceStar in self.collectionArrCenter) {
        if ([faceStar isEqualWithUserCode:model.userCode]) {
            [self.collectionArrCenter removeObject:faceStar];
            [UIView animateWithDuration:0.3 animations:^{
                faceStar.alpha = 0;
            } completion:^(BOOL finished) {
                [faceStar removeFromSuperview];
            }];
            
            return;
        }
    }
    
    for (XMBiuFaceStar *faceStar in self.collectionArrOutside) {
        if ([faceStar isEqualWithUserCode:model.userCode]) {
            [self.collectionArrOutside removeObject:faceStar];
            [UIView animateWithDuration:0.3 animations:^{
                faceStar.alpha = 0;
            } completion:^(BOOL finished) {
                [faceStar removeFromSuperview];
            }];
            
            return;
        }
    }
}

/**
 *  清理超时头像
 *
 *  @param timer 定时器
 */
//- (void)onCleanFaceStar:(NSTimer*)timer{
//    [self cleanFaceStarTrajectory0];
//    
//    [self cleanFaceStarTrajectory1];
//    
//    [self cleanFaceStarTrajectory2];
//}

/**
 *  清理第一圈超时头像
 */
- (void)cleanFaceStarTrajectory0{
    if (self.collectionArrInside.count > 0) {
        XMBiuFaceStar *olderInsideFaceStar = self.collectionArrInside[0];
        
        if ([NSDate currentTimeMillisSecond] - olderInsideFaceStar.birthday > self.collectionMaxTimeInside) {
            if (self.collectionArrOutside.count >= self.collectionMaxCountOutside) {
                XMBiuFaceStar *olderOutsideFaceStar = self.collectionArrOutside[0];
                [self.collectionArrOutside removeObjectAtIndex:0];
                [olderOutsideFaceStar hiddenAndDestroy];
            }
            
            if (self.collectionArrCenter.count >= self.collectionMaxCountCenter) {
                XMBiuFaceStar *olderCenterFaceStar = self.collectionArrCenter[0];
                [self.collectionArrCenter removeObjectAtIndex:0];
                BOOL resTransfer = [olderCenterFaceStar transferToNextTrajectoryWithTargetCollectionFaceStar:self.collectionArrOutside];
                if (resTransfer) {
                    [self.collectionArrOutside addObject:olderCenterFaceStar];
                }
            }
            
            XMBiuFaceStar *olderInsideFaceStar = self.collectionArrInside[0];
            [self.collectionArrInside removeObjectAtIndex:0];
            BOOL resTransfer = [olderInsideFaceStar transferToNextTrajectoryWithTargetCollectionFaceStar:self.collectionArrCenter];
            if (resTransfer) {
                [self.collectionArrCenter addObject:olderInsideFaceStar];
            }
        }
    }
}

/**
 *  清理第二圈超时头像
 */
- (void)cleanFaceStarTrajectory1{
    if (self.collectionArrCenter.count > 0) {
        XMBiuFaceStar *olderCenterFaceStar = self.collectionArrCenter[0];
        
        if ([NSDate currentTimeMillisSecond] - olderCenterFaceStar.birthday > self.collectionMaxTimeCenter) {
            if (self.collectionArrOutside.count >= self.collectionMaxCountOutside) {
                XMBiuFaceStar *olderOutsideFaceStar = self.collectionArrOutside[0];
                [self.collectionArrOutside removeObjectAtIndex:0];
                [olderOutsideFaceStar hiddenAndDestroy];
            }
            
            XMBiuFaceStar *olderCenterFaceStar = self.collectionArrCenter[0];
            [self.collectionArrCenter removeObjectAtIndex:0];
            BOOL resTransfer = [olderCenterFaceStar transferToNextTrajectoryWithTargetCollectionFaceStar:self.collectionArrOutside];
            if (resTransfer) {
                [self.collectionArrOutside addObject:olderCenterFaceStar];
            }
        }
    }
}

/**
 *  清理第三圈超时头像
 */
- (void)cleanFaceStarTrajectory2{
    if (self.collectionArrOutside.count > 0) {
        XMBiuFaceStar *olderOutsideFaceStar = self.collectionArrOutside[0];
        
        if ([NSDate currentTimeMillisSecond] - olderOutsideFaceStar.birthday > self.collectionMaxTimeOutside) {
            XMBiuFaceStar *olderOutsideFaceStar = self.collectionArrOutside[0];
            [self.collectionArrOutside removeObjectAtIndex:0];
            [olderOutsideFaceStar hiddenAndDestroy];
        }
    }
}

- (NSInteger)countOfFaceStar{
    NSInteger count = 0;
    count += self.collectionArrInside.count;
    count += self.collectionArrCenter.count;
    count += self.collectionArrOutside.count;
    
    return count;
}

#pragma mark - 头像回调
- (void)xmBiuFaceStar:(XMBiuFaceStar *)view onClickProfileWithModel:(ModelBiuFaceStar *)model{
    if (self.delegateFaceStarCollection) {
        if ([self.delegateFaceStarCollection respondsToSelector:@selector(xmBiuFaceStarCollection:onClickProfileWithModel:)]) {
            [self.delegateFaceStarCollection xmBiuFaceStarCollection:self onClickProfileWithModel:model];
        }
    }
}


#pragma mark - 基础数据
- (CGPoint)circleCenter{
    return CGPointMake(self.superViewSize.width/2, self.superViewSize.height/2);
}

- (NSInteger)collectionMaxTimeInside{
    return 900;
}

- (NSInteger)collectionMaxTimeCenter{
    return 1800;
}

- (NSInteger)collectionMaxTimeOutside{
    return 3600;
}

- (NSInteger)collectionMaxCountInside{
    return 4;
}

- (NSInteger)collectionMaxCountCenter{
    return 6;
}

- (NSInteger)collectionMaxCountOutside{
    return 8;
}

- (NSMutableArray *)collectionArrInside{
    if (!_collectionArrInside) {
        _collectionArrInside = [NSMutableArray array];
    }
    return _collectionArrInside;
}

- (NSMutableArray *)collectionArrCenter{
    if (!_collectionArrCenter) {
        _collectionArrCenter = [NSMutableArray array];
    }
    return _collectionArrCenter;
}

- (NSMutableArray *)collectionArrOutside{
    if (!_collectionArrOutside) {
        _collectionArrOutside = [NSMutableArray array];
    }
    return _collectionArrOutside;
}

@end
