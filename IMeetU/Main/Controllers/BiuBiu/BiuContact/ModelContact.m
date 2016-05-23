//
//  ModelContact.m
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelContact.h"
#import "DBSchools.h"
#import "DBCacheBiuContact.h"

@implementation ModelContact

+ (instancetype)modelWithUserCode:(NSString *)userCode{
    return [[DBCacheBiuContact shareDAO] selectContactWithUserCode:userCode];
}

- (NSString *)profileUrl{
    return _profileUrl?_profileUrl:@"";
}

- (NSString *)userCode{
    return _userCode?_userCode:@"";
}

- (NSString *)nameNick{
    return _nameNick?_nameNick:@"";
}

- (NSString *)constellation{
    return _constellation?_constellation:_constellation;
}

- (NSString *)schoolName{
    DBSchools *dao = [DBSchools shareInstance];
    return [dao schoolNameWithID:[self.schoolId integerValue]];
}

- (NSNumber *)ageObj{
    return [NSNumber numberWithInteger:self.age];
}

- (NSNumber *)genderObj{
    return [NSNumber numberWithInteger:self.gender];
}

- (NSNumber *)isGraduatedObj{
    return [NSNumber numberWithInteger:self.isGraduated];
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"profileUrl":@"icon_thumbnailUrl",
             @"userCode":@"user_code",
             @"nameNick":@"nickname",
             @"age":@"age",
             @"gender":@"sex",
             @"isGraduated":@"isgraduated",
             @"constellation":@"starsign",
             @"schoolId":@"school"
             };
}

@end
