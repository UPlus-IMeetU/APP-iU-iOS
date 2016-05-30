//
//  ModelTag.m
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelTag.h"

@implementation ModelTag
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tagId" : @"id",
             @"content" : @"content"};
}
@end
