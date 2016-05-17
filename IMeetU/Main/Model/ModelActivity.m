//
//  ModelActivity.m
//  IMeetU
//
//  Created by Spring on 16/5/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelActivity.h"

@implementation ModelActivity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"actys":[ModelAdvert class]};
}
@end
