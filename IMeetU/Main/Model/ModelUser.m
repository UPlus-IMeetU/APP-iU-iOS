//
//  ModelUser.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelUser.h"

@implementation ModelUser

- (NSString *)personalIntroductions{
    if (!_personalIntroductions) {
        return @"在这里介绍一下自己咯，关于爱情、关于成长、关于生活的种种......你想着什么样的人，最终会遇到什么样的人。So，给每一位来到这里的TA送上你的祝福。在这里介绍一下自己咯，关于爱情、关于成长、关于生活的种种......你想着什么样的人，最终会遇到什么样的人。So，给每一位来到这里的TA送上你的祝福。";
    }
    return _personalIntroductions;
}

+ (NSArray *)allCharater{
    return @[
             @"安静", @"浪漫", @"吃货", @"高冷", @"高热", @"随性", @"随便", @"女神经", @"女变态", @"大叔控", @"小鲜肉", @"微腐", @"腐透了", @"女汉子", @"直爽", @"豪杰"
             ];
}

@end
