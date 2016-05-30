//
//  ModelCommunity.m
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCommunity.h"
#import "ModelPost.h"
#import "ModelAdvert.h"
@implementation ModelCommunity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banner":[ModelAdvert class],
             @"postList":[ModelPost class]};
}
@end
