//
//  ModelPostDetail.m
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelPostDetail.h"
#import "ModelTag.h"
#import "ModelComment.h"
@implementation ModelPostDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tags":[ModelTag class],
             @"commentList":[ModelComment class]};
}
@end
