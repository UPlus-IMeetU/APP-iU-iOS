//
//  ModelActivityContents.m
//  IMeetU
//
//  Created by Spring on 16/5/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelActivityContents.h"

@implementation ModelActivityContents
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"contents":[ModelAdvert class]};
}

@end
