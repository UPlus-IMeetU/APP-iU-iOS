//
//  CellCollectionMineAlterInterest.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellCollectionMineAlterInterest.h"
#import "ModelMineAlterInterest.h"
#import "ModelInterest.h"

@interface CellCollectionMineAlterInterest()

@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBg;

@end
@implementation CellCollectionMineAlterInterest

- (void)initWithModelInterest:(ModelMineAlterInterest *)model sectionTitle:(NSString *)sectionTitle{
    [self.labelContent setText:model.interestContent];
    if (model.selected) {
        [self.labelContent setTextColor:[UIColor whiteColor]];
        [self.imgViewBg setImage:[self bgNameSelectedWithSectionTitle:sectionTitle]];
    }else{
        [self.labelContent setTextColor:[UIColor blackColor]];
        [self.imgViewBg setImage:[self bgNameWithSectionTitle:sectionTitle]];
    }
}

- (UIImage*)bgNameSelectedWithSectionTitle:(NSString*)title{
    return [UIImage imageNamed:[CellCollectionMineAlterInterest bgSelectedWithKey:title]];
}

- (UIImage*)bgNameWithSectionTitle:(NSString*)title{
    return [UIImage imageNamed:[CellCollectionMineAlterInterest bgWithKey:title]];
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
    NSString *value = [CellCollectionMineAlterInterest valuesOfTitle:key];
    return [NSString stringWithFormat:@"mine_interest_img_tab_bg_%@", value];
}

+ (NSString *)bgSelectedWithKey:(NSString *)key{
    NSString *value = [CellCollectionMineAlterInterest valuesOfTitle:key];
    return [NSString stringWithFormat:@"mine_interest_img_tab_bg_%@_selected", value];
}

@end
