//
//  ModelMineAlterInterests.m
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelMineAlterInterestAll.h"
#import "ModelMineAlterInterestSection.h"
#import "ModelMineAlterInterest.h"

@implementation ModelMineAlterInterestAll


- (NSInteger)numberOfSections{
    return self.interestAll.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    if (section < self.numberOfSections) {
        ModelMineAlterInterestSection *m = self.interestAll[section];
        return m.numberOfInterests;
    }
    return 0;
}

- (NSString *)titleOfHeaderInSection:(NSInteger)section{
    if (section < self.numberOfSections) {
        ModelMineAlterInterestSection *m = self.interestAll[section];
        return m.sectionTitle;
    }
    return @"";
}

- (ModelMineAlterInterest *)modelInterestForCellAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.numberOfSections) {
        ModelMineAlterInterestSection *m = self.interestAll[indexPath.section];
        
        return [m modelInterestForCellAtRow:indexPath.row];
    }
    return nil;
}

- (void)onSelectedOfIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.numberOfSections) {
        ModelMineAlterInterestSection *m = self.interestAll[indexPath.section];
        
        ModelMineAlterInterest *interest = [m modelInterestForCellAtRow:indexPath.row];
        interest.selected = !interest.selected;
    }
}

- (NSArray *)selected{
    NSMutableArray *selected = [NSMutableArray array];
    for (ModelMineAlterInterestSection *ms in self.interestAll) {
        for (ModelMineAlterInterest *mi in ms.interests) {
            if (mi.selected) {
                mi.sectionTitle = ms.sectionTitle;
                [selected addObject:mi];
            }
        }
    }
    return selected;
}

+ (NSArray *)sectionNameKeys{
    return @[@"music", @"movie", @"book", @"sport"];
}

+ (NSString *)sectionNameKeysWithTitle:(NSString*)title{
    NSDictionary *dic = @{
                          @"书籍":@"book",
                          @"音乐":@"music",
                          @"运动":@"sport",
                          @"电影":@"movie",
                          };
    
    return dic[title];
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

- (UIImage *)pointImgOfSection:(NSInteger)section{
    NSString *key = [ModelMineAlterInterestAll sectionNameKeysWithTitle:[self titleOfHeaderInSection:section]];
    return [UIImage imageNamed:[ModelMineAlterInterestAll pointWithKey:key]];
}

- (float)heightTableViewOfRow:(NSInteger)row{
    float height = 0;
    if (row == 0) {
        return 22.5;
    }else if (row>0 && row<self.numberOfSections+1){
        row -= 1;
        if ([self numberOfItemsInSection:row]%4 == 0) {
            height = ((int)[self numberOfItemsInSection:row]/4)*38 - 13 + 72;
        }else{
            height = ((int)[self numberOfItemsInSection:row]/4+1)*38 - 13 + 72;
        }
    }else{
        height = 100-22.5;
    }
    
    return height;
}


+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"interestAll":@"tags",
             @"token":@"token"
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"interestAll", @"token"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"interestAll":[ModelMineAlterInterestSection class]
             };
}

@end
