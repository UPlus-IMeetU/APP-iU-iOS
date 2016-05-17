//
//  ModelSchools.m
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ModelSchools.h"
#import "DBSchools.h"

@interface ModelSchools()

//所有学校集合
@property (nonatomic, strong) NSArray *allSchools;
//模糊匹配得到的结果
@property (nonatomic, strong) NSArray *subSchools;
//模糊匹配所需的匹配关键字
@property (nonatomic, copy) NSString *subKey;

@end
@implementation ModelSchools


-(NSArray *)allSchools{
    if (_allSchools == nil) {
        _allSchools = [[DBSchools shareInstance] selectAllSchool];
    }
    return _allSchools;
}

-(NSArray *)subSchools{
    if (_subSchools == nil) {
        if (self.subKey != nil && self.subKey.length > 0) {
            _subSchools = [[DBSchools shareInstance] selectSchoolWithKey:self.subKey];
        }
    }
    return _subSchools;
}

-(NSInteger)allSchoolsCount{
    return self.allSchools.count;
}

-(NSInteger)subSchoolsCount{
    return self.subSchools.count;
}

-(NSString*)schoolNameFromAllWithLoc:(NSInteger)loc{
    NSDictionary *school = self.allSchools[loc];
    return school[@"schoolName"];
}

-(NSString*)schoolNameFromSubWithLoc:(NSInteger)loc{
    NSDictionary *school = self.subSchools[loc];
    return school[@"schoolName"];
}

-(void)updateSubSchoolsWithKey:(NSString *)key{
    if (![key isEqual:self.subKey]) {
        self.subKey = key;
        if (self.subKey != nil && self.subKey.length > 0) {
            self.subSchools = [[DBSchools shareInstance] selectSchoolWithKey:key];
        }else{
            self.subSchools = nil;
        }
    }
}



-(NSInteger)sectionCount{
    return 3;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return [self subSchoolsCount];
    }else if(section == 2){
        return [self allSchoolsCount];
    }
    return 0;
}

-(NSString*)titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"匹配学校";
    }else if (section == 2){
        return @"所有学校";
    }
    return @"";
}

- (NSDictionary*)schoolForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        return self.subSchools[indexPath.row];
    }else if (indexPath.section == 2){
        return self.allSchools[indexPath.row];
    }
    return nil;
}

@end
