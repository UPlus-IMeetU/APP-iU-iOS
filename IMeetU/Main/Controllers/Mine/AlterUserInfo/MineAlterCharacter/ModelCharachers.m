//
//  ModelResponseCharachers.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCharachers.h"
#import "ModelCharacher.h"
#import <YYKit/YYKit.h>

@implementation ModelCharachers

- (NSInteger)characterCount{
    return self.characters.count;
}

- (ModelCharacher *)characterOfIndex:(NSInteger)index{
    if (index < self.characterCount) {
        return self.characters[index];
    }
    return nil;
}

- (NSArray*)selected{
    NSMutableArray *selected = [NSMutableArray array];
    for (ModelCharacher *m in self.characters) {
        if (m.isSelected) {
            [selected addObject:m];
        }
    }
    return selected;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"characters":@"tags",
             @"token":@"token"
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"characters", @"token"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"characters":[ModelCharacher class]
             };
}

@end
