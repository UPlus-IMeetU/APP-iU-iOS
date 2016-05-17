//
//  ModelMineAlterInterest.m
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelMineAlterInterest.h"

@implementation ModelMineAlterInterest

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"interestContent":@"name",
             @"interestCode":@"code",
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"interestContent", @"interestCode"];
}

- (UIImage*)bgNameSelected{
    return [UIImage imageNamed:[ModelMineAlterInterest bgSelectedWithKey:self.sectionTitle]];
}

- (UIImage*)bgName{
    return [UIImage imageNamed:[ModelMineAlterInterest bgWithKey:self.sectionTitle]];
}

+ (NSString*)valuesOfTitle:(NSString*)title{
    NSDictionary *dic = @{
                          @"运动":@"sport",
                          @"音乐":@"music",
                          @"书籍":@"book",
                          @"电影":@"movie"
                          };
    return dic[title];
}

+ (NSString *)bgWithKey:(NSString *)key{
    NSString *value = [ModelMineAlterInterest valuesOfTitle:key];
    return [NSString stringWithFormat:@"mine_interest_img_tab_bg_%@", value];
}

+ (NSString *)bgSelectedWithKey:(NSString *)key{
    NSString *value = [ModelMineAlterInterest valuesOfTitle:key];
    return [NSString stringWithFormat:@"mine_interest_img_tab_bg_%@_selected", value];
}

@end
