//
//  XMBiuCenterButton.m
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMBiuCenterView.h"
#import <YYKit/YYKit.h>
#import "POP.h"

#import "UINib+Plug.h"
#import "NSDate+plug.h"

#define animationBLN @"animationBLN"

@interface XMBiuCenterView()

@property (nonatomic, assign) CGFloat viewWidthHeight;
@property (nonatomic, assign) CGFloat btnBiuWidthHeight;
@property (nonatomic, assign) NSInteger biubiuStep;
@property (nonatomic, assign) NSInteger biubiuCount;
@property (nonatomic, assign) NSInteger biubiuNowCount;
@property (nonatomic, assign) NSInteger biuCountdownStartTime;
@property (nonatomic, assign) CGPoint viewOrigin;
@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, assign) CGFloat circleBorderWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewWaterWave;
@property (weak, nonatomic) IBOutlet UILabel *labelBiuBiu;
@property (weak, nonatomic) IBOutlet UIButton *btnBiuBiu;
@property (weak, nonatomic) IBOutlet UIButton *btnSuccessfulMatches;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnBiuWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnBiuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnSuccessfulMatchesWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnSuccessfulMatchesHeight;

@property (nonatomic, strong) NSTimer *timerCountdown;

@property (nonatomic, strong) ModelBiuFaceStar *modelFaceStar;
@end
@implementation XMBiuCenterView

+ (instancetype)biuCenterButtonWithOrigin:(CGPoint)origin{
    XMBiuCenterView *biuCenterButton = [UINib xmViewWithName:@"XMBiuCenterView" class:[XMBiuCenterView class]];
    biuCenterButton.viewOrigin = origin;
    [biuCenterButton initial];
    
    return biuCenterButton;
}

- (void)awakeFromNib{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.imgViewWaterWave setImage:[UIImage imageNamed:@"biu_waterwave"]];
    [self.imgViewWaterWave.layer addAnimation:[self AlphaLight:2] forKey:animationBLN];
    self.imgViewWaterWave.layer.cornerRadius = self.viewWidthHeight/2;
    self.imgViewWaterWave.layer.masksToBounds = YES;
    
    self.btnBiuBiu.layer.cornerRadius = self.btnBiuWidthHeight/2;
    self.btnBiuBiu.layer.masksToBounds = YES;
    
    self.btnSuccessfulMatches.layer.cornerRadius = (self.btnBiuWidthHeight+self.circleBorderWidth*2)/2;
    self.btnSuccessfulMatches.layer.masksToBounds = YES;
}

- (void)initial{
    
}

- (void)layoutSubviews{
    self.frame = CGRectMake(0, 0, self.viewWidthHeight, self.viewWidthHeight);
    self.center = self.viewOrigin;
    
    
    self.constraintBtnBiuWidth.constant = self.btnBiuWidthHeight;
    self.constraintBtnBiuHeight.constant = self.btnBiuWidthHeight;
    
    self.constraintBtnSuccessfulMatchesWidth.constant = self.btnBiuWidthHeight+self.circleBorderWidth*2;
    self.constraintBtnSuccessfulMatchesHeight.constant = self.btnBiuWidthHeight+self.circleBorderWidth*2;
}

- (void)viewWillAppear{
}

- (void)noReceiveMatchUser{
    self.btnBiuBiu.hidden = NO;
    self.btnSuccessfulMatches.hidden = YES;
}

- (void)receiveMatcheUserWithImage:(UIImage*)image{
    self.btnSuccessfulMatches.alpha = 0;
    [self.btnSuccessfulMatches setHidden:NO];
    [self.btnSuccessfulMatches setImage:image forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.btnSuccessfulMatches.alpha = 1;
    }];
}

//- (void)receiveMatcheUserWithModel:(ModelBiuFaceStar *)model animation:(BOOL)animation{
//    self.btnSuccessfulMatches.alpha = 0;
//    [self.btnSuccessfulMatches setHidden:NO];
//    __weak UIButton *weakBtnSuccessfulMatches = self.btnSuccessfulMatches;
//    
//    self.modelFaceStar = model;
//    [self.btnSuccessfulMatches setBackgroundImageWithURL:[NSURL URLWithString:model.userProfile] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"global_profile_defult"] options:YYWebImageOptionAllowBackgroundTask completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        
//        [weakBtnSuccessfulMatches setBackgroundImage:image forState:UIControlStateHighlighted];
//        self.biubiuNowCount = 0;
//        [self setNeedsDisplay];
//        
//        [self.labelBiuBiu setHidden:YES];
//        [self.btnBiuBiu setHidden:YES];
//        [self.labelBiuBiu setText:@""];
//        [self.btnBiuBiu setTitle:@"biu" forState:UIControlStateNormal];
//        [self.timerCountdown invalidate];
//        self.timerCountdown = nil;
//        
//        POPSpringAnimation *scaleAnimationSuccessfulMatches = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//        scaleAnimationSuccessfulMatches.springBounciness = 10;
//        scaleAnimationSuccessfulMatches.springSpeed = 20;
//        scaleAnimationSuccessfulMatches.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//        scaleAnimationSuccessfulMatches.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
//        
//        
//        POPBasicAnimation *opacityAnimationSuccessfulMatches = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//        opacityAnimationSuccessfulMatches.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        opacityAnimationSuccessfulMatches.duration = 0.3;
//        opacityAnimationSuccessfulMatches.toValue = @1.0;
//        
//        scaleAnimationSuccessfulMatches.completionBlock = ^(POPAnimation *anim, BOOL finish){
//        };
//        
//        if (animation) {
//            [weakBtnSuccessfulMatches.layer pop_addAnimation:scaleAnimationSuccessfulMatches forKey:@"AnimationScale"];
//        }
//        [weakBtnSuccessfulMatches.layer pop_addAnimation:opacityAnimationSuccessfulMatches forKey:@"AnimateOpacity"];
//
//    }];
//}

-(CABasicAnimation *) AlphaLight:(float)time{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.1f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

- (IBAction)onClickBtnBiuBiu:(id)sender {
    if (self.delegateBiuCenter) {
        if ([self.delegateBiuCenter respondsToSelector:@selector(biuCenterButton:onClickBtnSenderBiu:isTimeout:)]) {
            BOOL isTimeout = ([NSDate currentTimeMillisSecond] - self.biuCountdownStartTime) > self.biubiuCount/self.biubiuStep;
            [self.delegateBiuCenter biuCenterButton:self onClickBtnSenderBiu:sender isTimeout:isTimeout];
        }
    }
}

- (IBAction)onClickBtnSuccessfulMatches:(id)sender {
    if (self.delegateBiuCenter) {
        if ([self.delegateBiuCenter respondsToSelector:@selector(biuCenterButton:onClickBtnSuccessfulMatches:model:)]) {
            [self.delegateBiuCenter biuCenterButton:self onClickBtnSuccessfulMatches:self.btnSuccessfulMatches model:self.modelFaceStar];
        }
    }
    
    [self.btnBiuBiu setHidden:NO];
    [self.btnSuccessfulMatches setHidden:YES];
}

- (void)onBiubiuing:(NSTimer*)timer{
    self.biubiuNowCount --;
    if (self.biubiuNowCount<=0 || self.biubiuNowCount>self.biubiuCount) {
        [self.timerCountdown invalidate];
        self.timerCountdown = nil;
        [self.labelBiuBiu setText:@""];
        [self.labelBiuBiu setHidden:YES];
        [self.btnBiuBiu setTitle:@"biu" forState:UIControlStateNormal];
    }else{
        if (self.biubiuNowCount % self.biubiuStep == 0) {
            [self.labelBiuBiu setText:[NSString stringWithFormat:@"%luS", self.biubiuNowCount/8]];
        }
        [self setNeedsDisplay];
    }
}

- (void)timerCountdownStart{
    self.biuCountdownStartTime = [NSDate currentTimeMillisSecond];
    self.biubiuNowCount = self.biubiuCount;

    [self.labelBiuBiu setText:[NSString stringWithFormat:@"%luS", self.biubiuCount/self.biubiuStep]];
    [self.labelBiuBiu setHidden:NO];
    [self.btnBiuBiu setTitle:@"" forState:UIControlStateNormal];
    
    self.timerCountdown = [NSTimer scheduledTimerWithTimeInterval:1.0/self.biubiuStep target:self selector:@selector(onBiubiuing:) userInfo:nil repeats:YES];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context,1.0,1.0,1.0,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, self.circleBorderWidth);
    CGContextAddArc(context, self.viewWidthHeight/2, self.viewWidthHeight/2, self.circleRadius, 0, M_PI*2*self.biubiuNowCount/self.biubiuCount, 0); //添加一个圆
    
    CGContextDrawPath(context, kCGPathStroke);
}

- (CGFloat)viewWidthHeight{
    return 124;
}

- (NSInteger)biubiuStep{
    return 8;
}

- (NSInteger)biubiuCount{
    return 720;
}

- (CGFloat)circleBorderWidth{
    return 2;
}
- (CGFloat)circleRadius{
    return (self.btnBiuWidthHeight+self.circleBorderWidth)/2;
}

- (CGFloat)btnBiuWidthHeight{
    return 64;
}

@end
