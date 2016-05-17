//
//  XMBiuCircularTrajectory.m
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMBiuCircularTrajectory.h"

#define PI 3.14159265358979323846

@interface XMBiuCircularTrajectory()

@property (nonatomic, strong) NSArray *trajectoryRadiusArr;
@property (nonatomic, assign) CGSize viewSize;

@end
@implementation XMBiuCircularTrajectory

+ (instancetype)biuCircularTrajectoryWithSize:(CGSize)size trajectoryRadiusArr:(NSArray *)trajectoryRadiusArr{
    XMBiuCircularTrajectory *biuCircularTrajectory = [[XMBiuCircularTrajectory alloc] init];
    [biuCircularTrajectory initWithSize:size trajectoryRadiusArr:trajectoryRadiusArr];
    return biuCircularTrajectory;
}

- (void)initWithSize:(CGSize)size trajectoryRadiusArr:(NSArray *)trajectoryRadiusArr{
    self.viewSize = size;
    self.trajectoryRadiusArr = trajectoryRadiusArr;
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.frame = CGRectMake(0, 0, size.width, size.height);
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextAddArc(context, self.viewSize.width/2, self.viewSize.height/2, [self trajectoryRadiusWithIndex:0], 0, (PI*2), 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetRGBStrokeColor(context,1,1,1,0.56);//画笔线的颜色
    CGContextAddArc(context, self.viewSize.width/2, self.viewSize.height/2, [self trajectoryRadiusWithIndex:1], 0, (PI*2), 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetRGBStrokeColor(context,1,1,1,0.48);//画笔线的颜色
    CGContextAddArc(context, self.viewSize.width/2, self.viewSize.height/2, [self trajectoryRadiusWithIndex:2], 0, (PI*2), 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke);
}

- (CGFloat)trajectoryRadiusWithIndex:(NSInteger)index{
    if (index >= self.trajectoryRadiusArr.count) {
        return 0;
    }
    return [self.trajectoryRadiusArr[index] floatValue];
}

@end
