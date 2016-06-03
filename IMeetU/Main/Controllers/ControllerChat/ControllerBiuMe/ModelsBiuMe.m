//
//  ModelsBiuMe.m
//  IMeetU
//
//  Created by zhanghao on 16/6/3.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelsBiuMe.h"
#import "ModelBiuMe.h"

@implementation ModelsBiuMe

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return self.biuList.count;
}

- (ModelBiuMe*)modelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.biuList.count) {
        return self.biuList[indexPath.row];
    }
    return nil;
}

- (void)additionalBiuMe:(NSArray *)biuMeList{
    [self.biuList addObjectsFromArray:biuMeList];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"biuList" : [ModelBiuMe class]
             };
}

@end
