//
//  XMBiuFaceStar.m
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMBiuFaceStar.h"
#import "Math.h"
#import "UINib+Plug.h"
#import "NSDate+plug.h"
#import "UIScreen+Plug.h"
#import "POP.h"
#import "ModelBiuFaceStar.h"
#import <YYKit/YYKit.h>

#import "CABasicAnimation+plug.h"

#define PI 3.14159265358979323846

@interface XMBiuFaceStar()

@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *profileUrl;

@property (nonatomic, assign) CGFloat trajectoryRadius;
@property (nonatomic, assign) NSInteger trajectoryIndex;
@property (nonatomic, strong) NSArray *trajectoryRadiusArr;

@property (nonatomic, assign) CGPoint circleCenter;

@property (nonatomic, assign) CGFloat viewWH;
@property (nonatomic, strong) NSArray *viewWHs;

@property (nonatomic, assign) CGFloat profileWH;
@property (nonatomic, strong) NSArray *profileWHs;

@property (nonatomic, assign) CGFloat tagPointWH;
@property (nonatomic, strong) NSArray *tagPointWHs;

@property (nonatomic, assign) CGFloat edgeAngle;
/**
 *  轨道3在屏幕上显示的角度（四分之一）
 */
@property (nonatomic, assign) NSInteger trajectory3ShowAngle_4;

@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProfileWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProfileHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProfileBgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProfileBgHeight;


@property (weak, nonatomic) IBOutlet UIImageView *imgViewWaterWave;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileCircle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPoint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTagPointOffsetX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTagPointOffsetY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTagPointWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTagPointHeight;

@property (nonatomic, strong) ModelBiuFaceStar *modelFaceStar;

@end
@implementation XMBiuFaceStar

+ (instancetype)biuFaceStarWithModel:(ModelBiuFaceStar*)model trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr circleCenter:(CGPoint)circleCenter collectionFaceStarInside:(NSArray *)collectionFaceStarInside{
    XMBiuFaceStar *biuFaceStar = [UINib xmViewWithName:@"XMBiuFaceStar" class:[XMBiuFaceStar class]];
    
    BOOL initResult = [biuFaceStar initialWithModel:(ModelBiuFaceStar*)model trajectoryRadiusArr:trajectoryRadiusArr circleCenter:circleCenter collectionFaceStarInside:collectionFaceStarInside];
    
    if (initResult) {
        return biuFaceStar;
    }
    return nil;
}

+ (instancetype)biuFaceStarWithTrajectoryIndex:(NSInteger)index model:(ModelBiuFaceStar*)model trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr circleCenter:(CGPoint)circleCenter collectionFaceStar:(NSArray *)collectionFaceStar{
    XMBiuFaceStar *biuFaceStar = [UINib xmViewWithName:@"XMBiuFaceStar" class:[XMBiuFaceStar class]];
    [biuFaceStar setBackgroundColor:[UIColor clearColor]];
    biuFaceStar.trajectoryRadiusArr = trajectoryRadiusArr;
    biuFaceStar.circleCenter = circleCenter;
    
    biuFaceStar.trajectoryIndex = index;
    biuFaceStar.constraintProfileWidth.constant = biuFaceStar.profileWH;
    biuFaceStar.constraintProfileHeight.constant = biuFaceStar.profileWH;
    biuFaceStar.constraintProfileBgWidth.constant = biuFaceStar.profileWH+3;
    biuFaceStar.constraintProfileBgHeight.constant = biuFaceStar.profileWH+3;
    biuFaceStar.constraintTagPointOffsetX.constant = biuFaceStar.profileWH/2-biuFaceStar.tagPointWH/2;
    biuFaceStar.constraintTagPointOffsetY.constant = biuFaceStar.profileWH/2-biuFaceStar.tagPointWH/2;
    biuFaceStar.constraintTagPointWidth.constant = biuFaceStar.tagPointWH;
    biuFaceStar.constraintTagPointHeight.constant = biuFaceStar.tagPointWH;
    
    biuFaceStar.modelFaceStar = model;
    
    biuFaceStar.birthday = model.matchTime/1000;
    biuFaceStar.imgViewPoint.hidden = model.haveSee;
    
    [biuFaceStar.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:model.userProfile] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"global_profile_defult"]];
    
    BOOL initSuccess = NO;
    int i = 0;
    for (i=0; i<100; i++) {
        if (index==0 || index==1) {
            biuFaceStar.positionAngle = arc4random()%360;
        }else if (index == 2){
            NSInteger randomAngle = arc4random()%([biuFaceStar trajectory3ShowAngle_4]*2);
            if (arc4random()%2==0) {
                biuFaceStar.positionAngle = 90+90-[biuFaceStar trajectory3ShowAngle_4]+randomAngle;
            }else{
                biuFaceStar.positionAngle = 270+90-[biuFaceStar trajectory3ShowAngle_4]+randomAngle;
                if (biuFaceStar.positionAngle>360) {
                    biuFaceStar.positionAngle = biuFaceStar.positionAngle-360;
                }
            }
        }
        
        if (![biuFaceStar haveOverlapWithTargetCollectionFaceStars:collectionFaceStar]) {
            initSuccess = YES;
            break;
        }
    }
    
    if (initSuccess) {
        biuFaceStar.positionX = biuFaceStar.circleCenter.x + sin(biuFaceStar.positionAngle/180*PI)*biuFaceStar.trajectoryRadius;
        biuFaceStar.positionY = biuFaceStar.circleCenter.y + cos(biuFaceStar.positionAngle/180*PI)*biuFaceStar.trajectoryRadius;
        return biuFaceStar;
    }
    
    return nil;
}

- (ModelBiuFaceStar *)getModel{
    return self.modelFaceStar;
}

- (BOOL)isEqualWithUserCode:(NSString *)userCode{
    return [self.modelFaceStar.userCode isEqualToString:userCode];
}

- (void)showNormalFaceStarWithSuperView:(UIView *)superView{
    self.alpha = 0;
    [superView addSubview:self];
    self.frame = CGRectMake(self.positionX, self.positionY, self.viewWH, self.viewWH);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (BOOL)initialWithModel:(ModelBiuFaceStar*)model trajectoryRadiusArr:(NSArray*)trajectoryRadiusArr circleCenter:(CGPoint)circleCenter collectionFaceStarInside:(NSArray *)collectionFaceStarInside{
    [self setBackgroundColor:[UIColor clearColor]];
    self.trajectoryRadiusArr = trajectoryRadiusArr;
    self.circleCenter = circleCenter;
    
    self.trajectoryIndex = 0;
    self.constraintProfileWidth.constant = self.profileWH;
    self.constraintProfileHeight.constant = self.profileWH;
    
    self.modelFaceStar = model;
    
    self.birthday = model.matchTime/1000;
    self.imgViewPoint.hidden = model.haveSee;
    
    
    [self.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:model.userProfile] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"global_profile_defult"]];
    
    BOOL initSuccess = NO;
    int i = 0;
    for (i=0; i<100; i++) {
        self.positionAngle = arc4random()%360;
        
        if (![self haveOverlapWithTargetCollectionFaceStars:collectionFaceStarInside]) {
            initSuccess = YES;
            break;
        }
    }
    
    if (initSuccess) {
        self.positionX = self.circleCenter.x + sin(self.positionAngle/180*PI)*self.trajectoryRadius;
        self.positionY = self.circleCenter.y + cos(self.positionAngle/180*PI)*self.trajectoryRadius;
    }
    
    return initSuccess;
}

- (BOOL)initialWithTrajectoryRadiusArr:(NSArray*)trajectoryRadiusArr circleCenter:(CGPoint)circleCenter collectionFaceStar:(NSArray *)collectionFaceStar trajectoryIndex:(NSInteger)trajectoryIndex{
    
    return NO;
}

- (void)layoutSubviews{
    self.frame = CGRectMake(0, 0, self.viewWH, self.viewWH);
    self.center = CGPointMake(self.positionX, self.positionY);
}

- (void)showFaceStarWithSuperView:(UIView*)superView{
    self.alpha = 1;
    [superView addSubview:self];
    
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.duration = 0.3;
    opacityAnimation.toValue = @1.0;
    
    scaleAnimation.completionBlock = ^(POPAnimation *animation, BOOL success){
        self.imgViewWaterWave.hidden = NO;
        CABasicAnimation *animationStar =[CABasicAnimation animationWithKeyPath:@"opacity"];
        animationStar.fromValue = @0;
        animationStar.toValue = @1.0;//这是透明度。
        animationStar.autoreverses = YES;
        animationStar.duration = 0.8;
        animationStar.repeatCount = 10;
        animationStar.removedOnCompletion = NO;
        animationStar.fillMode = kCAFillModeForwards;
        animationStar.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [self.imgViewWaterWave.layer addAnimation:animationStar forKey:@"animationStar"];
    };
    
    POPSpringAnimation *sizeAnimationCircle = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnimationCircle.springBounciness = 10;
    sizeAnimationCircle.springSpeed = 20;
    sizeAnimationCircle.fromValue = [NSValue valueWithCGSize:self.imgProfileCircle.frame.size];
    sizeAnimationCircle.toValue = [NSValue valueWithCGSize:CGSizeMake(self.profileWH+3, self.profileWH+3)];
    [self.imgProfileCircle.layer pop_addAnimation:sizeAnimationCircle forKey:@"AnimationSize"];
    
    [self.btnProfile.layer pop_addAnimation:scaleAnimation forKey:@""];
    [self.imgViewWaterWave.layer pop_addAnimation:scaleAnimation forKey:@""];
    [self.layer pop_addAnimation:opacityAnimation forKey:@""];
    
    self.constraintTagPointOffsetX.constant = self.profileWH/2 - self.tagPointWH/2-2;
    self.constraintTagPointOffsetY.constant = self.profileWH/2 - self.tagPointWH/2-2;
    self.constraintTagPointWidth.constant = self.tagPointWH;
    self.constraintTagPointHeight.constant = self.tagPointWH;
}

- (BOOL)transferToNextTrajectoryWithTargetCollectionFaceStar:(NSArray *)collectionFaceStar{
    [self.imgViewWaterWave setHidden:YES];
    if (self.trajectoryIndex == 0) {
        return [self transferToCenterTrajectoryWithTargetCollectionFaceStar:collectionFaceStar];
    }else if (self.trajectoryIndex == 1){
        return [self transferToOutsideTrajectoryWithTargetCollectionFaceStar:collectionFaceStar];
    }
    return NO;
}

- (BOOL)transferToCenterTrajectoryWithTargetCollectionFaceStar:(NSArray *)collectionFaceStar{
    self.trajectoryIndex = 1;
    BOOL transferSuccess = NO;
    
    CGFloat angleStart = 0;
    NSInteger angleRange = 90;
    if (self.positionAngle < 45) {
        angleStart = 0;
    }else if (self.positionAngle > 315){
        angleStart = 315;
    }else{
        angleStart = self.positionAngle - 45;
    }
    int i=0;
    for ( i=0; i<100; i++) {
        self.positionAngle = angleStart + arc4random()%angleRange;
        
        if (![self haveOverlapWithTargetCollectionFaceStars:collectionFaceStar]) {
            transferSuccess = YES;
            break;
        }
    }
    
    if (transferSuccess) {
        self.positionX = self.circleCenter.x + sin(self.positionAngle/180*PI)*self.trajectoryRadius;
        self.positionY = self.circleCenter.y + cos(self.positionAngle/180*PI)*self.trajectoryRadius;
    }else{
        for (int i=0; i<100; i++) {
            self.positionAngle = arc4random()%360;
            
            if (![self haveOverlapWithTargetCollectionFaceStars:collectionFaceStar]) {
                transferSuccess = YES;
                break;
            }
        }
    }
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 10;
    positionAnimation.springSpeed = 20;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.positionX, self.positionY)];
    [self.layer pop_addAnimation:positionAnimation forKey:@"AnimationPosition"];
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnimation.springBounciness = 10;
    sizeAnimation.springSpeed = 20;
    sizeAnimation.fromValue = [NSValue valueWithCGSize:self.btnProfile.frame.size];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(self.profileWH, self.profileWH)];
    [self.btnProfile.layer pop_addAnimation:sizeAnimation forKey:@"AnimationSize"];
    
    POPSpringAnimation *sizeAnimationCircle = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnimationCircle.springBounciness = 10;
    sizeAnimationCircle.springSpeed = 20;
    sizeAnimationCircle.fromValue = [NSValue valueWithCGSize:self.imgProfileCircle.frame.size];
    sizeAnimationCircle.toValue = [NSValue valueWithCGSize:CGSizeMake(self.profileWH+3, self.profileWH+3)];
    [self.imgProfileCircle.layer pop_addAnimation:sizeAnimationCircle forKey:@"AnimationSize"];
    
    self.constraintProfileBgHeight.constant = self.profileWH+3;
    self.constraintProfileBgWidth.constant = self.profileWH+3;
    self.constraintTagPointOffsetX.constant = self.profileWH/2 - self.tagPointWH/2;
    self.constraintTagPointOffsetY.constant = self.profileWH/2 - self.tagPointWH/2;
    self.constraintTagPointWidth.constant = self.tagPointWH;
    self.constraintTagPointHeight.constant = self.tagPointWH;
    [self layoutSubviews];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.8;
    }];
    
    return transferSuccess;
}

- (BOOL)transferToOutsideTrajectoryWithTargetCollectionFaceStar:(NSArray *)collectionFaceStarInside{
    self.trajectoryIndex = 2;
    BOOL transferSuccess = NO;
    
    CGFloat angleStart;
    NSInteger angleRange = self.trajectory3ShowAngle_4 - self.edgeAngle*2;
    if (self.positionAngle >=0 && self.positionAngle < 90) {
        angleStart = self.edgeAngle;
    }else if (self.positionAngle >= 90 && self.positionAngle < 180){
        angleStart = 180 - self.trajectory3ShowAngle_4 + self.edgeAngle;
    }else if (self.positionAngle >= 180 && self.positionAngle < 270){
        angleStart = 180 + self.edgeAngle;
    }else{
        angleStart = 360 - self.trajectory3ShowAngle_4 + self.edgeAngle;
    }
    
    int i=0;
    for (i=0; i<100; i++) {
        self.positionAngle = angleStart + arc4random()%angleRange;
        
        if (![self haveOverlapWithTargetCollectionFaceStars:collectionFaceStarInside]) {
            transferSuccess = YES;
            break;
        }
    }
    
    self.positionX = self.circleCenter.x + sin(self.positionAngle/180*PI)*self.trajectoryRadius;
    self.positionY = self.circleCenter.y + cos(self.positionAngle/180*PI)*self.trajectoryRadius;
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 10;
    positionAnimation.springSpeed = 20;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.positionX, self.positionY)];
    [self.layer pop_addAnimation:positionAnimation forKey:@"AnimationPosition"];
    
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    sizeAnimation.springBounciness = 10;
    sizeAnimation.springSpeed = 20;
    sizeAnimation.fromValue = [NSValue valueWithCGSize:self.btnProfile.frame.size];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(self.profileWH, self.profileWH)];
    sizeAnimation.completionBlock = ^(POPAnimation *animation, BOOL success){
        //self.btnProfile.bounds = CGRectMake(0, 0, self.profileWH, self.profileWH);
        //self.bounds = CGRectMake(0, 0, self.viewWH, self.viewWH);
        //[self.btnProfile pop_removeAllAnimations];
    };
    [self.btnProfile pop_addAnimation:sizeAnimation forKey:@"AnimationSize"];
    
    POPSpringAnimation *sizeAnimationCircle = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnimationCircle.springBounciness = 10;
    sizeAnimationCircle.springSpeed = 20;
    sizeAnimationCircle.fromValue = [NSValue valueWithCGSize:self.imgProfileCircle.frame.size];
    sizeAnimationCircle.toValue = [NSValue valueWithCGSize:CGSizeMake(self.profileWH+3, self.profileWH+3)];
    [self.imgProfileCircle.layer pop_addAnimation:sizeAnimationCircle forKey:@"AnimationSize"];
    
    self.constraintProfileBgHeight.constant = self.profileWH+3;
    self.constraintProfileBgWidth.constant = self.profileWH+3;
    self.constraintTagPointOffsetX.constant = self.profileWH/2 - self.tagPointWH/2;
    self.constraintTagPointOffsetY.constant = self.profileWH/2 - self.tagPointWH/2;
    self.constraintTagPointWidth.constant = self.tagPointWH;
    self.constraintTagPointHeight.constant = self.tagPointWH;
    [self layoutSubviews];
    
    return transferSuccess;
}

- (BOOL)haveOverlapWithTargetCollectionFaceStars:(NSArray *)collectionFaceStars{
    if (collectionFaceStars.count == 0) {
        return NO;
    }
    for (XMBiuFaceStar *faceStar in collectionFaceStars) {
        CGFloat angleSubtract = ABS(self.positionAngle - faceStar.positionAngle);
        if (angleSubtract < self.edgeAngle*2 || angleSubtract > 360-self.edgeAngle*2) {
            return YES;
        }
    }
    return NO;
}

- (void)hiddenAndDestroy{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.duration = 0.3;
    opacityAnimation.toValue = @0;
    
    scaleAnimation.completionBlock = ^(POPAnimation *animation, BOOL success){
        [self removeFromSuperview];
    };
    
    [self.btnProfile.layer pop_addAnimation:scaleAnimation forKey:@""];
    [self.imgViewWaterWave.layer pop_addAnimation:scaleAnimation forKey:@""];
    [self.layer pop_addAnimation:opacityAnimation forKey:@""];
}

#pragma mark - 点击头像
- (IBAction)onClickBtnProfile:(id)sender {
    if (self.delegateFaceStar) {
        if ([self.delegateFaceStar respondsToSelector:@selector(xmBiuFaceStar:onClickProfileWithModel:)]) {
            [self.delegateFaceStar xmBiuFaceStar:self onClickProfileWithModel:self.modelFaceStar];
            self.imgViewPoint.hidden = YES;
            self.modelFaceStar.haveSee = YES;
        }
    }
}

#pragma mark - 基础数据
- (CGFloat)trajectoryRadius{
    return [self.trajectoryRadiusArr[self.trajectoryIndex] floatValue];
}

- (CGFloat)viewWH{
    return [self.viewWHs[self.trajectoryIndex] floatValue];
}
- (NSArray *)viewWHs{
    return @[@65, @34 ,@25];
}

- (CGFloat)profileWH{
    return [self.profileWHs[self.trajectoryIndex] floatValue];
}
- (NSArray *)profileWHs{
    return @[@46, @34, @25];
}

- (CGFloat)tagPointWH{
    return [self.tagPointWHs[self.trajectoryIndex] floatValue];
}
- (NSArray *)tagPointWHs{
    return @[@8, @7, @6];
}

- (CGFloat)edgeAngle{
    CGFloat edgeAngle = asin(self.viewWH/1.8 / self.trajectoryRadius) / PI *180;
    
    return edgeAngle;
}

- (NSInteger)trajectory3ShowAngle_4{
    CGFloat radius = [self.trajectoryRadiusArr[2] floatValue];
    NSInteger angle = 90 - acos([UIScreen screenWidth]/2 / radius) / PI * 180;
    
    return angle;
}
@end
