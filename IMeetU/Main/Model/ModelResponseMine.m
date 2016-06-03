//
//  ModelResponseMine.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelResponseMine.h"

#import "ModelCharacher.h"
#import "ModelMineAlterInterest.h"
#import "ModelMinePhoto.h"

@implementation ModelResponseMine

- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

+ (NSDictionary *)modelCustomPropertyMapper{

    return @{
             @"profileCircle":@"photoCircle",
             @"profileOrigin":@"photoOrigin",
             @"profileStatus":@"photoStatus",
             @"photos":@"photos",
             @"aboutMe":@"description",
             @"nameNick":@"nickname",
             @"gender":@"sex",
             @"birthday":@"birth_date",
             @"constellation":@"starsign",
             @"city":@"city",
             @"homeTown":@"hometown",
             @"bodyHeight":@"height",
             @"bodyWeight":@"weight",
             @"isGraduated":@"isgraduated",
             @"profession":@"career",
             @"school":@"school",
             @"company":@"company",
             
             @"characters":@"personality_tags",
             @"interested_tags":@"interested_tags",
            
             @"distanceToTA":@"distance",
             @"matchScore":@"matching_score",
             @"actyTime":@"activity_time",
             @"userIdentifier":@"superman",
             @"biuCode":@"code",
             @"todayNum":@"today_num",
             @"totalNum":@"total_num"
             };
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

+ (NSArray *)modelPropertyBlacklist {
    return @[@"charactersCount", @"interestsCount"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"photos":[ModelMinePhoto class],
             @"characters":[ModelCharacher class],
             @"interests":[NSDictionary class]
             };
}

@end
