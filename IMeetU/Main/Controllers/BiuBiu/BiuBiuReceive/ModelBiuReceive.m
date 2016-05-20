//
//  ModelBiuReceive.m
//  IMeetU
//
//  Created by zhanghao on 16/3/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuReceive.h"
#import "ModelCharacher.h"
#import "ModelMineAlterInterest.h"

@implementation ModelBiuReceive

- (NSInteger)age{
    if (_age>0 && _age<80) {
        return _age;
    }
    return 0;
}

- (ModelCharacher *)modelCharaterOfIndex:(NSInteger)index{
    if (index < self.characters.count) {
        return self.characters[index];
    }
    return nil;
}

- (ModelMineAlterInterest *)modelInterestOfIndex:(NSInteger)index{
    if (index < self.interests.count) {
        return self.interests[index];
    }
    return nil;
}


- (NSArray *)interests{
    if (!_interests) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in self.interested_tags) {
            NSArray *arr = dic[@"data"];
            NSString *sectionTitle = dic[@"typename"];
            for (NSDictionary *interest in arr) {
                ModelMineAlterInterest *model = [[ModelMineAlterInterest alloc] init];
                model.interestCode = interest[@"code"];
                model.interestContent = interest[@"name"];
                model.sectionTitle = sectionTitle;
                
                [mArr addObject:model];
            }
        }
        _interests = [NSArray arrayWithArray:mArr];
    }
    return _interests;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"token":@"token",
             @"userCode":@"user_code",
             @"nameNick":@"nickname",
             @"userProfile":@"icon_thumbnailUrl",
             @"userProfileOrigin":@"icon_url",
             @"gender":@"sex",
             @"age":@"age",
             @"constellation":@"starsign",
             @"schoolId":@"school",
             @"company":@"company",
             @"profression":@"carrer",
             @"timebefore":@"time",
             @"chatTopic":@"chat_tags",
             @"characters":@"hit_tags",
             @"interested_tags":@"interested_tags",
             @"characters":@"distance",
             @"matchingScore":@"matching_score",
             @"userIdentifier":@"superman",
             @"message":@"message",
             @"timebefore":@"time"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"characters" : [ModelCharacher class],
             @"interested_tags" : [NSDictionary class],
             };
}

@end
