//
//  ModelPost.m
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelPost.h"
#import "ModelTag.h"
#import "ModelImage.h"
#import "UIScreen+plug.h"
#import "UIFont+Plug.h"
@implementation ModelPost
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"tags":[ModelTag class],
             @"imgs":[ModelImage class]
             };
}

+ (CGFloat) cellHeightWith:(ModelPost *)modelPost{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSString *contentStr = modelPost.content;
    CGFloat titleSizeHeight = [UIFont getSpaceLabelHeight:modelPost.content withFont:[UIFont systemFontOfSize:13.0] withWidth:(width - 20) withLineSpacing:2.6];
    NSInteger imageCount = modelPost.imgs.count;
    NSInteger photoViewWidth = 0;
    if (imageCount == 0 || modelPost.imgs == nil) {
        photoViewWidth = -20;
    }else if(imageCount == 1){
        photoViewWidth = width - 20;
    }else if(imageCount == 2){
        photoViewWidth = (width - 20 - 5) * 0.5;
    }else if(imageCount == 3){
        photoViewWidth = ceil((width - 20 - 5 * 2) /  3);
    }else if(imageCount >3 && imageCount <= 6){
        photoViewWidth = ceil((width - 20 - 5 * 2) /  3) * 2 + 5;
    }else{
        photoViewWidth = ceil((width - 20 - 5 * 2) /  3) * 3 + 5 * 2;
    }
    return 180.0f +  ceil(titleSizeHeight) + photoViewWidth;
}
@end
