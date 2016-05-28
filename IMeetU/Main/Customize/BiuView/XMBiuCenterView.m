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
#import "UserDefultBiu.h"
#import "MLToast.h"

#define animationBLN @"animationBLN"

@interface XMBiuCenterView()

@property (nonatomic, assign) CGFloat viewWidthHeight;
@property (nonatomic, assign) CGFloat btnBiuWidthHeight;
@property (nonatomic, assign) NSInteger biubiuStep;
@property (nonatomic, assign) NSInteger biubiuCount;
@property (nonatomic, assign) NSInteger biubiuNowCount;
@property (nonatomic, assign) long long biuCountdownStartTime;
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
    
    self.btnSuccessfulMatches.layer.cornerRadius = self.btnBiuWidthHeight/2;
    self.btnSuccessfulMatches.layer.masksToBounds = YES;
}

- (void)layoutSubviews{
    self.frame = CGRectMake(0, 0, self.viewWidthHeight, self.viewWidthHeight);
    self.center = self.viewOrigin;
    
    self.constraintBtnBiuWidth.constant = self.btnBiuWidthHeight;
    self.constraintBtnBiuHeight.constant = self.btnBiuWidthHeight;
    
    self.constraintBtnSuccessfulMatchesWidth.constant = self.btnBiuWidthHeight;
    self.constraintBtnSuccessfulMatchesHeight.constant = self.btnBiuWidthHeight;
}

- (void)noReceiveMatchUser{
    self.btnBiuBiu.hidden = NO;
    self.btnSuccessfulMatches.hidden = YES;
}

- (void)receiveMatcheUserWithImageUrl:(NSString *)url{
    [self.btnSuccessfulMatches setHidden:NO];
    self.btnBiuBiu.hidden = YES;
    
    if (url && url.length>0) {
        [self timerCountdownShutDown];
        [self.btnSuccessfulMatches setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"biu_btn_matching"]];
    }else if ([UserDefultBiu biuSendTime] + 90*1000 > [NSDate currentTimeMillis]){
        [self.btnSuccessfulMatches setBackgroundImage:[UIImage imageNamed:@"biu_btn_matching_bg"] forState:UIControlStateNormal];
        [self timerCountdownStart];
    }else{
        [self.btnSuccessfulMatches setBackgroundImage:[UIImage imageNamed:@"biu_btn_matching"] forState:UIControlStateNormal];
        [self timerCountdownShutDown];
    }
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
}

- (void)timerCountdownStart{
    self.biuCountdownStartTime = [NSDate currentTimeMillis];
    self.biubiuNowCount = self.biubiuCount*(1 - (self.biuCountdownStartTime-[UserDefultBiu biuSendTime])/90.0/1000);
    
    [self.labelBiuBiu setText:[NSString stringWithFormat:@"%luS", self.biubiuNowCount/self.biubiuStep]];
    [self.labelBiuBiu setHidden:NO];
    [self.btnSuccessfulMatches setHidden:NO];
    
    [self.timerCountdown invalidate];
    self.timerCountdown = nil;
    self.timerCountdown = [NSTimer scheduledTimerWithTimeInterval:1.0/self.biubiuStep target:self selector:@selector(onBiubiuing:) userInfo:nil repeats:YES];
}

- (void)timerCountdownShutDown{
    [self.timerCountdown invalidate];
    self.timerCountdown = nil;
    [self.labelBiuBiu setText:@""];
    [self.labelBiuBiu setHidden:YES];
}

- (void)onBiubiuing:(NSTimer*)timer{
    self.biubiuNowCount --;
    if (self.biubiuNowCount<=0 || self.biubiuNowCount>self.biubiuCount) {
        [self timerCountdownShutDown];
        
        //切换状态
        [self.btnSuccessfulMatches setBackgroundImage:[UIImage imageNamed:@"biu_btn_matching"] forState:UIControlStateNormal];
        
        if (self.delegateBiuCenter){
            if ([self.delegateBiuCenter respondsToSelector:@selector(biuCenterButtonCountdownEnd:)]) {
                [self.delegateBiuCenter biuCenterButtonCountdownEnd:self];
            }
        }
    }else{
        if (self.biubiuNowCount % self.biubiuStep == 0) {
            [self.labelBiuBiu setText:[NSString stringWithFormat:@"%luS", self.biubiuNowCount/self.biubiuStep]];
        }
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context,1.0,1.0,1.0,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, self.circleBorderWidth);
    CGContextAddArc(context, self.viewWidthHeight/2, self.viewWidthHeight/2, self.circleRadius, 0, M_PI*2*self.biubiuNowCount/self.biubiuCount, 0); //添加一个圆
    
    CGContextDrawPath(context, kCGPathStroke);
}

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
