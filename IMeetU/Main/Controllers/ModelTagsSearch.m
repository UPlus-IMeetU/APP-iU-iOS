//
//  ModelTagsSearch.m
//  IMeetU
//
//  Created by zhanghao on 16/5/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelTagsSearch.h"
#import "ModelTag.h"

@implementation ModelTagsSearch

- (NSInteger)numberOfSections{
    if (self.postTags.count>0) {
        ModelTag *model = self.postTags[0];
        if ([model.content isEqualToString:self.searchStr]) {
            return 1;
        }else{
            if (self.isCreate) {
                return 2;
            }else{
                return 1;
            }
        }
    }else{
        if (self.isCreate){
            return 2;
        }else{
            return 1;
        }
    }
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    if ([self numberOfSections] == 1) {
        if (section == 0) {
            return self.postTags.count;
        }
    }else if([self numberOfSections] == 2){
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return self.postTags.count;
        }
    }
    return 0;
}

- (NSString *)titleWithIndex:(NSInteger)index{
    if ([self numberOfSections] == 1) {
        return @"匹配话题";
    }else if([self numberOfSections] == 2){
        if (index == 0) {
            return @"新建话题";
        }else if (index == 1){
            return @"匹配话题";
        }
    }
    return @"";
}

- (NSString *)tagContentWithIndexPath:(NSIndexPath *)indexPath{
    if ([self numberOfSections] == 1) {
        ModelTag *model = self.postTags[indexPath.row];
        return model.content;
    }else if([self numberOfSections] == 2){
        if (indexPath.section == 0) {
            return self.searchStr;
        }else if (indexPath.section == 1){
            ModelTag *model = self.postTags[indexPath.row];
            return model.content;
        }
    }
    return @"";
}

- (ModelTag *)modelWithIndexPath:(NSIndexPath *)indexPath{
    if ([self numberOfSections] == 1) {
        return self.postTags[indexPath.row];
    }else if([self numberOfSections] == 2){
        if (indexPath.section == 0) {
            
        }else if (indexPath.section == 1){
            return self.postTags[indexPath.row];
        }
    }
    return nil;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"token" : @"token",
             @"num" : @"num",
             @"postTags" : @"tags"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"postTags" : [ModelTag class]
             };
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"searchStr"];
}
@end
