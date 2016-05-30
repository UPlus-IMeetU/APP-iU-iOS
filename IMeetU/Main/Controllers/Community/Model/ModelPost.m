//
//  ModelPost.m
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelPost.h"
#import "ModelTag.h"
@implementation ModelPost
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"tags":[ModelTag class]
             };
}
@end
