//
//  ModelMineAlterInterestSection.m
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelMineAlterInterestSection.h"
#import "ModelMineAlterInterest.h"

@implementation ModelMineAlterInterestSection

- (NSInteger)numberOfInterests{
    return self.interests.count;
}

- (ModelMineAlterInterest *)modelInterestForCellAtRow:(NSInteger)row{
    if (row < self.numberOfInterests) {
        ModelMineAlterInterest *m = self.interests[row];
        return m;
    }
    return nil;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"sectionTitle":@"typename",
             @"sectionCode":@"typecode",
             @"interests":@"data"
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"sectionTitle", @"sectionCode", @"interests"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"interests":[ModelMineAlterInterest class]
             };
}

@end
