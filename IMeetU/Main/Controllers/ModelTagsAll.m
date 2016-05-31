//
//  ModelTagsAll.m
//  IMeetU
//
//  Created by zhanghao on 16/5/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelTagsAll.h"

@interface ModelTagsAll()

@property (nonatomic, strong) NSArray *titles;

@end
@implementation ModelTagsAll

- (void)additionalNewerWithTags:(NSArray *)tags{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.postNewest];
    [arr addObjectsFromArray:tags];
    self.postNewest = [NSArray arrayWithArray:arr];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:return self.postRecommend.count;
        case 1:return self.postHot.count;
        case 2:return self.postNewest.count;
    }
    return 0;
}

- (NSInteger)numberOfSections{
    return self.titles.count;
}

- (NSString *)titleWithIndex:(NSInteger)index{
    if (index < self.titles.count) {
        return self.titles[index];
    }
    return @"";
}

- (NSString *)tagContentWithIndexPath:(NSIndexPath *)indexPath{
    return [self modelWithIndexPath:indexPath].content;
}

- (ModelTag *)modelWithIndexPath:(NSIndexPath *)indexPath{
    ModelTag *model;
    
    if (indexPath.section == 0) {
        model = self.postRecommend[indexPath.row];
    }else if (indexPath.section == 1){
        model = self.postHot[indexPath.row];
    }else if (indexPath.section == 2){
        model = self.postNewest[indexPath.row];
    }
    
    return model;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"iU推荐", @"热门话题", @"最新话题"];
    }
    return _titles;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"postRecommend" : @"recommend",
             @"postHot" : @"hot",
             @"postNewest" : @"new"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"postRecommend" : [ModelTag class],
             @"postHot" : [ModelTag class],
             @"postNewest" : [ModelTag class]
             };
}

@end
