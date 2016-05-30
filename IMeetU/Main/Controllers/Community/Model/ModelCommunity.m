//
//  ModelCommunity.m
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCommunity.h"
#import "ModelPost.h"
#import "ModelBanner.h"
@implementation ModelCommunity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banner":[ModelBanner class],
             @"postList":[ModelPost class]};
}
@end
