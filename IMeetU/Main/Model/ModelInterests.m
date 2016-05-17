//
//  ModelInterests.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelInterests.h"
#import "ModelInterest.h"

@implementation ModelInterests

+ (instancetype)modelInterestsWithSelected:(NSDictionary *)selected{
    ModelInterests *models = [[ModelInterests alloc] init];
    models.interestsSelected = selected;
    
    return models;
}

- (NSInteger)sectionCount{
    return [ModelInterests sectionNameKeys].count;
}

- (NSInteger)countOfSection:(NSInteger)section{
    if (section < self.sectionCount) {
        NSDictionary *originData = [ModelInterests originData];
        NSString *sectionNameKey = [ModelInterests sectionNameKeys][section];
        NSArray *arr = originData[sectionNameKey];
        return arr.count;
    }
    return 0;
}

- (ModelInterest *)modelOfSectionKey:(NSString *)key index:(NSInteger)index{
    NSArray *interests = self.interests[key];
    if (interests) {
        if (index < interests.count) {
            return interests[index];
        }
    }
    return nil;
}

- (ModelInterest *)modelOfIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.sectionCount) {
        NSString *sectionNameKey = [ModelInterests sectionNameKeys][indexPath.section];
        NSArray *interests = self.interests[sectionNameKey];
        if (indexPath.row < interests.count) {
            return interests[indexPath.row];
        }
    }
    return nil;
}

- (NSDictionary *)interestsSelectedModelToDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *sectionKey in [ModelInterests sectionNameKeys]) {
        NSArray *interestsModel = self.interests[sectionKey];
        NSMutableArray *interests = [NSMutableArray array];
        for (ModelInterest *model in interestsModel) {
            if (model.selected) {
                [interests addObject:model.interest];
            }
        }
        [dic setObject:interests forKey:sectionKey];
    }
    
    return dic;
}

+ (NSArray *)interestsModelWithDic:(NSDictionary *)dic{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in [ModelInterests sectionNameKeys]) {
        NSArray *interestsSelected = dic[key];
        if (interestsSelected) {
            for (NSString *interest in interestsSelected) {
                ModelInterest *model = [[ModelInterest alloc] init];
                model.interest = interest;
                model.bgNameSelected = [ModelInterests bgSelectedWithKey:key];
                [arr addObject:model];
            }
        }
    }
    return arr;
}

+ (NSArray *)sectionNameKeys{
    return @[@"music", @"movie", @"book", @"sport"];
}

+ (NSDictionary *)sectionNames{
    return @{
             @"music":@"音乐",
             @"movie":@"电影",
             @"book":@"书籍",
             @"sport":@"运动"
             };
}

+ (NSDictionary *)originData{
    return @{
             @"music":@[@"经典", @"流行", @"欧美", @"日韩", @"港台", @"摇滚", @"爵士"],
             @"movie":@[@"日韩", @"欧美", @"港台", @"大陆", @"警匪", @"恐怖", @"战争"],
             @"book":@[@"教材", @"小说", @"哲学", @"科学", @"技术", @"杂志", @"诗集", @"其他"],
             @"sport":@[@"足球", @"篮球", @"棒球", @"桌球", @"乒乓球", @"橄榄球", @"游泳", @"跳水", @"武术", @"跳高", @"举重", @"射箭", @"田径", @"围棋"]
             };
}

+ (NSString *)bgWithKey:(NSString *)key{
    return [NSString stringWithFormat:@"mine_interest_img_tab_bg_%@", key];
}

+ (NSString *)bgSelectedWithKey:(NSString *)key{
    return [NSString stringWithFormat:@"mine_interest_img_tab_bg_%@_selected", key];
}

+ (NSString *)pointWithKey:(NSString *)key{
    return [NSString stringWithFormat:@"mine_interest_img_point_%@", key];
}

- (NSString *)titleOfSection:(NSInteger)section{
    if (section < [ModelInterests sectionNameKeys].count) {
        NSString *sectionNameKey = [ModelInterests sectionNameKeys][section];
        return [ModelInterests sectionNames][sectionNameKey];
    }
    return nil;
}

- (NSMutableDictionary*)interests{
    if (!_interests) {
        _interests = [NSMutableDictionary dictionary];
        for (NSString *key in [ModelInterests sectionNameKeys]) {
            NSArray *interests = [ModelInterests originData][key];
            NSArray *interestsSelected = self.interestsSelected[key];
            NSMutableArray *modelInterestArr = [NSMutableArray array];
            for (NSString *interest in interests) {
                ModelInterest *modelInterest = [[ModelInterest alloc] init];
                modelInterest.interest = interest;
                if (!interestsSelected) {
                    modelInterest.selected = NO;
                }else{
                    modelInterest.selected = !([interestsSelected indexOfObject:interest]==NSNotFound);
                }
                modelInterest.bgName = [ModelInterests bgWithKey:key];
                modelInterest.bgNameSelected = [ModelInterests bgSelectedWithKey:key];
                [modelInterestArr addObject:modelInterest];
            }
            
            [_interests setObject:modelInterestArr forKey:key];
        }
        
    }
    return _interests;
}

- (UIImage *)pointImgOfSection:(NSInteger)section{
    NSString *key = [ModelInterests sectionNameKeys][section];
    return [UIImage imageNamed:[ModelInterests pointWithKey:key]];
}

- (float)heightTableViewOfRow:(NSInteger)row{
    float height = 0;
    if (row == 0) {
        return 22.5;
    }else if (row>0 && row<self.sectionCount+1){
        row -= 1;
        if ([self countOfSection:row]%4 == 0) {
            height = ((int)[self countOfSection:row]/4)*38 - 13 + 72;
        }else{
            height = ((int)[self countOfSection:row]/4+1)*38 - 13 + 72;
        }
    }else{
        height = 100-22.5;
    }
    
    return height;
}

@end
