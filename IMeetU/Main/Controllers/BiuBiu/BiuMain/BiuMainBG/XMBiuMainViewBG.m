//
//  ViewBiuMainBG.m
//  IMeetU
//
//  Created by zhanghao on 16/3/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMBiuMainViewBG.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"
#import <QuartzCore/QuartzCore.h>

#import "XMBiuMainViewBGQuadCurve.h"
@interface XMBiuMainViewBG()

@property (weak, nonatomic) IBOutlet UIView *viewPoints;
@property (weak, nonatomic) IBOutlet UIView *viewStars;
@property (weak, nonatomic) IBOutlet UIView *viewClouds;
@property (weak, nonatomic) IBOutlet UIView *viewSunMonth;

@property (weak, nonatomic) IBOutlet UIImageView *viewSun;
@property (weak, nonatomic) IBOutlet UIImageView *viewMonth;

@property (nonatomic, assign) CGRect sunFrame;
@property (nonatomic, assign) CGPoint originPointSun;
@property (nonatomic, strong) NSArray *quadCurvesSun;

@property (nonatomic, assign) CGRect moonFrame;
@property (nonatomic, assign) CGPoint originPointMonth;
@property (nonatomic, strong) NSArray *quadCurvesMonth;

@property (nonatomic, strong) NSArray *cloudFrames;
@property (nonatomic, strong) NSArray *cloudStartPoint;
@property (nonatomic, strong) NSArray *cloudPaths;
@property (nonatomic, strong) NSArray *cloudKeyTimes;
@property (nonatomic, strong) NSArray *cloudDuration;

@property (nonatomic, strong) NSArray *pointFrames;
@property (nonatomic, strong) NSArray *pointDurations;
@property (nonatomic, strong) NSArray *pointFromAlpha;
@property (nonatomic, strong) NSArray *pointToAlpha;

@property (nonatomic, strong) NSArray *framesStar;
@property (nonatomic, strong) NSArray *durationsStar;
@property (nonatomic, strong) NSArray *starFromAlpha;
@property (nonatomic, strong) NSArray *starToAlpha;

@property (nonatomic, assign) CGFloat mountainHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMountainHeight;

@end
@implementation XMBiuMainViewBG

+ (instancetype)view{
    XMBiuMainViewBG *view = [UINib xmViewWithName:@"XMBiuMainViewBG" class:[XMBiuMainViewBG class]];
    
    return view;
}

- (void)awakeFromNib{
    self.viewSun.alpha = 0;
    self.viewMonth.alpha = 0;
    self.constraintMountainHeight.constant = self.mountainHeight;
}

- (void)layoutSubviews{
    [self.viewSun sizeToFit];
    [self.viewMonth sizeToFit];
}


- (void)launchAnimation{
    [self launchSun];
    [self launchMonth];
    [self launchAnimationCloud];
    [self launchAnimationPoint];
    [self launchAnimationStar];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSun.alpha = 1;
        self.viewMonth.alpha = 1;
    }];
    [self layoutIfNeeded];
}

- (void)launchSun{
    self.viewSun.frame = self.sunFrame;
    self.viewSun.image = [UIImage imageNamed:@"biu_main_anim_sun"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef animationPath = CGPathCreateMutable();
    CGPathMoveToPoint(animationPath, NULL, self.originPointSun.x, self.originPointSun.y);
    
    for (XMBiuMainViewBGQuadCurve *quadCurve in self.quadCurvesSun) {
        CGPathAddQuadCurveToPoint(animationPath, NULL, quadCurve.cpX, quadCurve.cpY, quadCurve.x, quadCurve.y);
    }

    animation.path = animationPath;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 120;
    animation.keyTimes = @[@0, @0.083, @0.167, @0.375, @0.458, @0.667, @0.917, @1.0];
    animation.repeatCount = NSIntegerMax;
    
    CGPathRelease(animationPath);
    [self.viewSun.layer addAnimation:animation forKey:@"animationSun"];
    /*
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    
    CGContextMoveToPoint(ctx, self.originPointSun.x, self.originPointSun.y);
    int i=0;
    for (XMBiuMainViewBGQuadCurve *quadCurve in self.quadCurvesSun) {
        CGContextAddQuadCurveToPoint(ctx, quadCurve.cpX, quadCurve.cpY, quadCurve.x, quadCurve.y);
        if (i%3==0) {
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        }else if (i%3==1){
            CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
        }else if (i%3==2){
            CGContextSetStrokeColorWithColor(ctx, [UIColor purpleColor].CGColor);
        }
        i++;
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextMoveToPoint(ctx, quadCurve.x, quadCurve.y);
    }
    
    //Draw the line
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //With the image, we need a UIImageView
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *curveView = [[UIImageView alloc] initWithImage:image];
    //Set the frame of the view - which is used to position it when we add it to our current UIView
    curveView.frame = self.bounds;
    curveView.backgroundColor = [UIColor clearColor];
    [self addSubview:curveView];
    */
}

- (void)launchMonth{
    self.viewMonth.frame = self.moonFrame;
    self.viewMonth.image = [UIImage imageNamed:@"biu_main_anim_moon"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef animationPath = CGPathCreateMutable();
    CGPathMoveToPoint(animationPath, NULL, self.originPointMonth.x, self.originPointMonth.y);
    
    for (XMBiuMainViewBGQuadCurve *quadCurve in self.quadCurvesMonth) {
        CGPathAddQuadCurveToPoint(animationPath, NULL, quadCurve.cpX, quadCurve.cpY, quadCurve.x, quadCurve.y);
    }
    
    animation.path = animationPath;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 120;
    animation.keyTimes = @[@0, @0.133, @0.516, @0.633, @0.866, @1.0];
    animation.repeatCount = NSIntegerMax;
    
    CGPathRelease(animationPath);
    [self.viewMonth.layer addAnimation:animation forKey:@"animationSun"];
    /*
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetStrokeColorWithColor(ctx, [UIColor magentaColor].CGColor);
    
    CGContextMoveToPoint(ctx, self.originPointMonth.x, self.originPointMonth.y);
    int i=0;
    for (XMBiuMainViewBGQuadCurve *quadCurve in self.quadCurvesMonth) {
        CGContextAddQuadCurveToPoint(ctx, quadCurve.cpX, quadCurve.cpY, quadCurve.x, quadCurve.y);
        if (i%3==1) {
            CGContextSetStrokeColorWithColor(ctx, [UIColor magentaColor].CGColor);
        }else if(i%3==2){
            CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
        }else{
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        }
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextMoveToPoint(ctx, quadCurve.x, quadCurve.y);
        i++;
    }
    
    //Draw the line
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //With the image, we need a UIImageView
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *curveView = [[UIImageView alloc] initWithImage:image];
    //Set the frame of the view - which is used to position it when we add it to our current UIView
    curveView.frame = self.bounds;
    curveView.backgroundColor = [UIColor clearColor];
    [self addSubview:curveView];
    */
}

- (void)launchAnimationCloud{
    int i=0;
    for (UIImageView *cloud in self.viewClouds.subviews) {
        cloud.image = [UIImage imageNamed:[NSString stringWithFormat:@"biu_main_anim_cloud_%i", i]];
        CGRect frame;
        [self.cloudFrames[i] getValue:&frame];
        
        cloud.frame = frame;
        
        CGMutablePathRef animationPath = CGPathCreateMutable();
        CGPoint pointStart = [self.cloudStartPoint[i] CGPointValue];
        CGPathMoveToPoint(animationPath, NULL, pointStart.x, pointStart.y);
        
        for (NSValue *pointValue in self.cloudPaths[i]) {
            CGPathAddLineToPoint(animationPath, NULL, [pointValue CGPointValue].x, [pointValue CGPointValue].y);
        }
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = animationPath;
        animation.duration = [self.cloudDuration[i] floatValue];
        animation.keyTimes = self.cloudKeyTimes[i];
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        CGPathRelease(animationPath);
        [cloud.layer addAnimation:animation forKey:[NSString stringWithFormat:@"cloud_%i", i]];
        
        i++;
    }
}

- (void)launchAnimationPoint{
    int i=0;
    for (UIImageView *point in self.viewPoints.subviews) {
        point.image = [UIImage imageNamed:[NSString stringWithFormat:@"biu_main_anim_point_%i", i]];
        
        CGRect frame;
        [self.pointFrames[i] getValue:&frame];
        point.frame = frame;
        
        CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = self.pointFromAlpha[i];
        animation.toValue = self.pointToAlpha[i];//这是透明度。
        animation.autoreverses = YES;
        animation.duration = [self.pointDurations[i] floatValue];
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [point.layer addAnimation:animation forKey:[NSString stringWithFormat:@"point_%i", i]];
        
        i++;
    }
}

- (void)launchAnimationStar{
    int i=0;
    for (UIImageView *star in self.viewStars.subviews) {
        star.image = [UIImage imageNamed:[NSString stringWithFormat:@"biu_main_anim_star_%i", i]];
        CGRect frame;
        [self.framesStar[i] getValue:&frame];
        star.frame = frame;
        
        CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = self.starFromAlpha[i];
        animation.toValue = self.starToAlpha[i];//这是透明度。
        animation.autoreverses = YES;
        animation.duration = [self.durationsStar[i] floatValue];
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [star.layer addAnimation:animation forKey:[NSString stringWithFormat:@"star_%i", i]];
        
        i++;
    }
}

- (CGRect)sunFrame{
    if ([UIScreen is35Screen]) {
        return CGRectMake(self.originPointSun.x-10.5, self.originPointSun.y-16.5, 30, 30);
    }else if ([UIScreen is40Screen]){
        return CGRectMake(self.originPointSun.x-10.5, self.originPointSun.y-16.5, 30, 30);
    }else if ([UIScreen is47Screen]){
        return CGRectMake(self.originPointSun.x-10.5, self.originPointSun.y-16.5, 30, 30);
    }else if ([UIScreen is55Screen]){
        return CGRectMake(self.originPointSun.x-10.5, self.originPointSun.y-16.5, 30, 30);
    }
    return CGRectZero;
}

- (CGPoint)originPointSun{
    if ([UIScreen is35Screen]) {
        return CGPointMake(157, 525);
    }else if ([UIScreen is40Screen]){
        return CGPointMake(157, 525);
    }else if ([UIScreen is47Screen]){
        return CGPointMake(185, 617);
    }else if ([UIScreen is55Screen]){
        return CGPointMake(204, 681);
    }
    return CGPointZero;
}

- (NSArray *)quadCurvesSun{
    if (!_quadCurvesSun) {
        if ([UIScreen is35Screen]) {
            _quadCurvesSun = @[
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:206 xpY:557 x:253 y:509],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:320 xpY:490 x:256 y:421],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:184 xpY:286 x:270 y:180],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:320 xpY:130 x:280 y:100],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:221 xpY:8 x:47 y:95],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:34 xpY:449 x:self.originPointSun.x y:self.originPointSun.y]
                               ];
        }else if ([UIScreen is40Screen]){
            _quadCurvesSun = @[
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:206 xpY:557 x:253 y:509],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:320 xpY:490 x:256 y:421],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:184 xpY:286 x:270 y:180],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:320 xpY:130 x:280 y:100],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:221 xpY:8 x:47 y:95],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:34 xpY:449 x:self.originPointSun.x y:self.originPointSun.y]
                               ];
        }else if ([UIScreen is47Screen]){
            _quadCurvesSun = @[
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:242 xpY:656 x:298 y:599],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:380 xpY:560 x:320 y:480],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:216 xpY:337 x:356 y:200],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:369 xpY:113 x:315 y:90],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:234 xpY:9 x:49 y:150],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:36 xpY:475 x:self.originPointSun.x y:self.originPointSun.y]
                               ];
        }else if ([UIScreen is55Screen]){
            _quadCurvesSun = @[
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:268 xpY:724 x:330 y:661],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:410 xpY:596 x:334 y:551],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:240 xpY:375 x:396 y:222],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:410 xpY:126 x:350 y:100],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:260 xpY:10 x:55 y:160],
                               [XMBiuMainViewBGQuadCurve quadCurveWithCpX:40 xpY:528 x:self.originPointSun.x y:self.originPointSun.y]
                               ];
        }
    }
    return _quadCurvesSun;
}
    
- (CGRect)moonFrame{
    if ([UIScreen is35Screen]) {
        return CGRectMake(self.originPointMonth.x-22, self.originPointMonth.y-22, 30, 30);
    }else if ([UIScreen is40Screen]){
        return CGRectMake(self.originPointMonth.x-22, self.originPointMonth.y-22, 30, 30);
    }else if ([UIScreen is47Screen]){
        return CGRectMake(self.originPointMonth.x-22, self.originPointMonth.y-22, 30, 30);
    }else if ([UIScreen is55Screen]){
        return CGRectMake(self.originPointMonth.x-22, self.originPointMonth.y-22, 30, 30);
    }
    return CGRectZero;
}

- (CGPoint)originPointMonth{
    if ([UIScreen is35Screen]) {
        return CGPointMake(210, 42);
    }else if ([UIScreen is40Screen]){
        return CGPointMake(210, 42);
    }else if ([UIScreen is47Screen]){
        return CGPointMake(248, 50);
    }else if ([UIScreen is55Screen]){
        return CGPointMake(276, 56);
    }
    return CGPointZero;
}

- (NSArray *)quadCurvesMonth{
    if (!_quadCurvesMonth) {
        if ([UIScreen is35Screen]) {
            _quadCurvesMonth = @[
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:170 xpY:9 x:128 y:42],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:15 xpY:238 x:42 y:510],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:115 xpY:476 x:153 y:443],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:306 xpY:297 x:272 y:153],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:268 xpY:76 x:self.originPointMonth.x y:self.originPointMonth.y]
                                 ];
        }else if ([UIScreen is40Screen]){
            _quadCurvesMonth = @[
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:170 xpY:9 x:128 y:42],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:15 xpY:238 x:42 y:510],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:115 xpY:476 x:153 y:443],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:306 xpY:297 x:272 y:153],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:268 xpY:76 x:self.originPointMonth.x y:self.originPointMonth.y]
                                 ];
        }else if ([UIScreen is47Screen]){
            _quadCurvesMonth = @[
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:199 xpY:11 x:151 y:49],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:18 xpY:279 x:50 y:595],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:135 xpY:558 x:180 y:522],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:360 xpY:349 x:324 y:180],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:315 xpY:90 x:self.originPointMonth.x y:self.originPointMonth.y]
                                 ];
        }else if ([UIScreen is55Screen]){
            _quadCurvesMonth = @[
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:222 xpY:13 x:168 y:55],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:20 xpY:310 x:50 y:661],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:150 xpY:620 x:200 y:580],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:400 xpY:388 x:360 y:202],
                                 [XMBiuMainViewBGQuadCurve quadCurveWithCpX:350 xpY:100 x:self.originPointMonth.x y:self.originPointMonth.y]
                                 ];
        }
    }
    return _quadCurvesMonth;
}

#pragma mark - Cloud
- (NSArray *)cloudFrames{
    if (!_cloudFrames) {
        if ([UIScreen is35Screen]) {
            _cloudFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(-55, 378, 133, 18)],
                             [NSValue valueWithCGRect:CGRectMake(76, 407, 43, 10)],
                             [NSValue valueWithCGRect:CGRectMake(0, 432, 110, 21)],
                             [NSValue valueWithCGRect:CGRectMake(280, 85, 35, 20)],
                             [NSValue valueWithCGRect:CGRectMake(292, 310, 34, 25)]
                             ];
        }else if ([UIScreen is40Screen]){
            _cloudFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(-55, 378, 133, 18)],
                             [NSValue valueWithCGRect:CGRectMake(76, 407, 43, 10)],
                             [NSValue valueWithCGRect:CGRectMake(0, 432, 110, 21)],
                             [NSValue valueWithCGRect:CGRectMake(280, 85, 35, 20)],
                             [NSValue valueWithCGRect:CGRectMake(292, 310, 34, 25)]
                             ];
        }else if ([UIScreen is47Screen]){
            _cloudFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(-65, 445, 157, 21)],
                             [NSValue valueWithCGRect:CGRectMake(90, 478, 50, 11)],
                             [NSValue valueWithCGRect:CGRectMake(0, 504, 126, 24)],
                             [NSValue valueWithCGRect:CGRectMake(324, 85, 40, 23)],
                             [NSValue valueWithCGRect:CGRectMake(342, 465, 39, 29)]
                             ];
        }else if ([UIScreen is55Screen]){
            _cloudFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(-72, 495, 174, 23)],
                             [NSValue valueWithCGRect:CGRectMake(100, 532, 56, 13)],
                             [NSValue valueWithCGRect:CGRectMake(0, 566, 143, 27)],
                             [NSValue valueWithCGRect:CGRectMake(366, 85, 46, 26)],
                             [NSValue valueWithCGRect:CGRectMake(382, 406, 44, 32)]
                             ];
        }
    }
    return _cloudFrames;
}

- (NSArray *)cloudStartPoint{
    if (!_cloudStartPoint) {
        if ([UIScreen is35Screen]) {
            return @[
                     [NSValue valueWithCGPoint:CGPointMake(12, 388)],
                     [NSValue valueWithCGPoint:CGPointMake(98, 412)],
                     [NSValue valueWithCGPoint:CGPointMake(55, 443)],
                     [NSValue valueWithCGPoint:CGPointMake(298, 85)],
                     [NSValue valueWithCGPoint:CGPointMake(309, 322)]
                     ];
        }else if ([UIScreen is40Screen]){
            return @[
                     [NSValue valueWithCGPoint:CGPointMake(12, 388)],
                     [NSValue valueWithCGPoint:CGPointMake(98, 412)],
                     [NSValue valueWithCGPoint:CGPointMake(55, 443)],
                     [NSValue valueWithCGPoint:CGPointMake(298, 85)],
                     [NSValue valueWithCGPoint:CGPointMake(309, 322)]
                     ];
        }else if ([UIScreen is47Screen]){
            return @[
                     [NSValue valueWithCGPoint:CGPointMake(13, 456)],
                     [NSValue valueWithCGPoint:CGPointMake(115, 485)],
                     [NSValue valueWithCGPoint:CGPointMake(65, 522)],
                     [NSValue valueWithCGPoint:CGPointMake(350, 85)],
                     [NSValue valueWithCGPoint:CGPointMake(363, 380)]
                     ];
        }else if ([UIScreen is55Screen]){
            return @[
                     [NSValue valueWithCGPoint:CGPointMake(15, 507)],
                     [NSValue valueWithCGPoint:CGPointMake(128, 538)],
                     [NSValue valueWithCGPoint:CGPointMake(72, 580)],
                     [NSValue valueWithCGPoint:CGPointMake(389, 85)],
                     [NSValue valueWithCGPoint:CGPointMake(404, 422)]
                     ];
        }
    }
    return _cloudStartPoint;
}

- (NSArray *)cloudPaths{
    if (!_cloudPaths) {
        if ([UIScreen is35Screen]) {
            _cloudPaths = @[
                            @[
                                [NSValue valueWithCGPoint:CGPointMake(144, 388)],
                                [NSValue valueWithCGPoint:CGPointMake(11, 388)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(290, 411)],
                                [NSValue valueWithCGPoint:CGPointMake(22, 411)],
                                [NSValue valueWithCGPoint:CGPointMake(98, 411)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(312, 443)],
                                [NSValue valueWithCGPoint:CGPointMake(55, 443)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(2, 85)],
                                [NSValue valueWithCGPoint:CGPointMake(298, 85)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(250, 322)],
                                [NSValue valueWithCGPoint:CGPointMake(306, 322)]
                                ]
                            ];
        }else if ([UIScreen is40Screen]){
            _cloudPaths = @[
                            @[
                                [NSValue valueWithCGPoint:CGPointMake(144, 388)],
                                [NSValue valueWithCGPoint:CGPointMake(11, 388)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(290, 411)],
                                [NSValue valueWithCGPoint:CGPointMake(22, 411)],
                                [NSValue valueWithCGPoint:CGPointMake(98, 411)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(312, 443)],
                                [NSValue valueWithCGPoint:CGPointMake(55, 443)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(2, 85)],
                                [NSValue valueWithCGPoint:CGPointMake(298, 85)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(250, 322)],
                                [NSValue valueWithCGPoint:CGPointMake(306, 322)]
                                ]
                            ];
        }else if ([UIScreen is47Screen]){
            _cloudPaths = @[
                            @[
                                [NSValue valueWithCGPoint:CGPointMake(170, 455)],
                                [NSValue valueWithCGPoint:CGPointMake(13, 455)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(342, 485)],
                                [NSValue valueWithCGPoint:CGPointMake(25, 485)],
                                [NSValue valueWithCGPoint:CGPointMake(115, 485)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(367, 522)],
                                [NSValue valueWithCGPoint:CGPointMake(65, 522)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(3, 85)],
                                [NSValue valueWithCGPoint:CGPointMake(342, 85)]
                                ],@[
                                [NSValue valueWithCGPoint:CGPointMake(295, 379)],
                                [NSValue valueWithCGPoint:CGPointMake(363, 379)]
                                ]
                            ];
        }else if ([UIScreen is55Screen]){
            _cloudPaths = @[
                             @[
                                 [NSValue valueWithCGPoint:CGPointMake(189, 507)],
                                 [NSValue valueWithCGPoint:CGPointMake(15, 507)]
                                 ],@[
                                 [NSValue valueWithCGPoint:CGPointMake(380, 538)],
                                 [NSValue valueWithCGPoint:CGPointMake(28, 538)],
                                 [NSValue valueWithCGPoint:CGPointMake(128, 538)]
                                 ],@[
                                 [NSValue valueWithCGPoint:CGPointMake(408, 580)],
                                 [NSValue valueWithCGPoint:CGPointMake(72, 580)]
                                 ],@[
                                 [NSValue valueWithCGPoint:CGPointMake(3, 85)],
                                 [NSValue valueWithCGPoint:CGPointMake(389, 85)]
                                 ],@[
                                 [NSValue valueWithCGPoint:CGPointMake(328, 422)],
                                 [NSValue valueWithCGPoint:CGPointMake(404, 422)]
                                 ]
                             ];
        }
    }
    
    return _cloudPaths;
}

- (NSArray *)cloudDuration{
    if (!_cloudDuration) {
        _cloudDuration = @[@74, @54, @46, @40, @56];
    }
    return _cloudDuration;
}

- (NSArray *)cloudKeyTimes{
    if (!_cloudKeyTimes) {
        _cloudKeyTimes = @[
                           @[@0, @0.5, @1.0],
                           @[@0, @0.26, @0.81, @1.0],
                           @[@0, @0.52, @1.0],
                           @[@0, @0.5, @1.0],
                           @[@0, @0.5, @1.0]
                           ];
    }
    
    return _cloudKeyTimes;
}


- (NSArray *)pointFrames{
    if (!_pointFrames) {
        if ([UIScreen is35Screen]) {
            _pointFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(54, 280, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(132, 66, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(148, 392, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(240, 142, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(246, 192, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(200, 200, 4,  4)]
                             ];
        }else if ([UIScreen is40Screen]){
            _pointFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(54, 280, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(132, 66, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(148, 392, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(240, 142, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(246, 192, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(200, 200, 4,  4)]
                             ];
        }else if ([UIScreen is47Screen]){
            _pointFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(14, 190, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(60, 330, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(162, 116, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(176, 420, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(246, 192, 4,  4)],
                             [NSValue valueWithCGRect:CGRectMake(360, 306, 4,  4)]
                             ];
        }else if ([UIScreen is55Screen]){
            _pointFrames = @[
                             [NSValue valueWithCGRect:CGRectMake(20, 200, 8.6, 9)],
                             [NSValue valueWithCGRect:CGRectMake(70, 350, 8.6, 9)],
                             [NSValue valueWithCGRect:CGRectMake(178, 120, 9, 9)],
                             [NSValue valueWithCGRect:CGRectMake(200, 450, 9, 9.6)],
                             [NSValue valueWithCGRect:CGRectMake(250, 550, 8.6, 9)],
                             [NSValue valueWithCGRect:CGRectMake(392, 326, 9, 9.6)]
                             ];
        }
    }
    return _pointFrames;
}

- (NSArray *)pointDurations{
    if (!_pointDurations) {
        _pointDurations = @[@8, @6, @5, @4, @6, @4];
    }
    return _pointDurations;
}

- (NSArray *)pointFromAlpha{
    if (!_pointFromAlpha) {
        _pointFromAlpha = @[@0.1, @0.1, @0, @0, @0, @0.1];
    }
    return _pointFromAlpha;
}

- (NSArray *)pointToAlpha{
    if (!_pointToAlpha) {
        _pointToAlpha = @[@0.8, @0.8, @1.0, @1.0, @1.0, @0.8];
    }
    return _pointToAlpha;
}

- (NSArray *)framesStar{
    if (!_framesStar) {
        if ([UIScreen is35Screen]) {
            _framesStar = @[
                            [NSValue valueWithCGRect:CGRectMake(300, 150, 10, 10)],
                            [NSValue valueWithCGRect:CGRectMake(250, 250, 10, 10)],
                            [NSValue valueWithCGRect:CGRectMake(200, 350, 10, 10)],
                            [NSValue valueWithCGRect:CGRectMake(150, 450, 10, 10)],
                            [NSValue valueWithCGRect:CGRectMake(50, 550, 10, 10)]
                            ];
        }else if ([UIScreen is40Screen]){
            _framesStar = @[
                            [NSValue valueWithCGRect:CGRectMake(12, 274, 12, 14)],
                            [NSValue valueWithCGRect:CGRectMake(194, 150, 13, 13)],
                            [NSValue valueWithCGRect:CGRectMake(230, 224, 6, 6)],
                            [NSValue valueWithCGRect:CGRectMake(262, 68, 14, 14)],
                            [NSValue valueWithCGRect:CGRectMake(274, 310, 6, 6)]
                            ];
        }else if ([UIScreen is47Screen]){
            _framesStar = @[
                            [NSValue valueWithCGRect:CGRectMake(36, 322, 14, 14)],
                            [NSValue valueWithCGRect:CGRectMake(222, 198, 14, 14)],
                            [NSValue valueWithCGRect:CGRectMake(258, 272, 6, 6)],
                            [NSValue valueWithCGRect:CGRectMake(284, 116, 14, 14)],
                            [NSValue valueWithCGRect:CGRectMake(284, 116, 6, 6)]
                            ];
        }else if ([UIScreen is55Screen]){
            _framesStar = @[
                            [NSValue valueWithCGRect:CGRectMake(48, 360, 24, 23.67)],
                            [NSValue valueWithCGRect:CGRectMake(252, 226, 24, 23.67)],
                            [NSValue valueWithCGRect:CGRectMake(288, 306, 12, 11.67)],
                            [NSValue valueWithCGRect:CGRectMake(326, 130, 24, 23.67)],
                            [NSValue valueWithCGRect:CGRectMake(342, 400, 10.6, 10.6)]
                            ];
        }
    }
    return _framesStar;
}

- (NSArray *)durationsStar{
    if (!_durationsStar) {
        _durationsStar = @[@4, @8, @6, @5, @7];
    }
    return _durationsStar;
}

- (NSArray *)starFromAlpha{
    if (!_starFromAlpha) {
        _starFromAlpha = @[@0.1, @0, @0.1, @0.1, @0];
    }
    return _starFromAlpha;
}

- (NSArray *)starToAlpha{
    if (!_starToAlpha) {
        _starToAlpha = @[@0.8, @1.0, @0.8, @0.8, @1.0];
    }
    return _starToAlpha;
}

- (CGFloat)mountainHeight{
    if ([UIScreen is35Screen]) {
        return 137;
    }else if ([UIScreen is40Screen]){
        return 137;
    }else if ([UIScreen is47Screen]){
        return 160;
    }else if ([UIScreen is55Screen]){
        return 174;
    }
    return 0;
}

@end
