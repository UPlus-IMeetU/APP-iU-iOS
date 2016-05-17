//
//  ModelBiuFaceStar.m
//  IMeetU
//
//  Created by zhanghao on 16/3/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuFaceStar.h"
#import "ModelRemoteNotification.h"

@implementation ModelBiuFaceStar

+ (instancetype)modelWithRemoteNiti:(ModelRemoteNotification *)model{
    ModelBiuFaceStar *faceStar = [[ModelBiuFaceStar alloc] init];
    
    faceStar.userCode = model.biuUserCode;
    faceStar.userName = model.biuUserName;
    faceStar.userAge = model.biuUserAge;
    faceStar.haveSee = NO;
    faceStar.userConstellation = model.biuUserConstellation;
    faceStar.schoolId = model.biuUserSchool;
    faceStar.company = model.biuUserCompany;
    faceStar.profession = model.biuUserProfession;
    faceStar.biuID = model.biuCode;
    faceStar.referenceId = model.referenceId;
    faceStar.userProfile = model.biuUserProfile;
    faceStar.matchTime = model.biuMatchTime;
    
    return faceStar;
}

- (NSInteger)matchTime{
    if (_matchTime==0) {
        return 1;
    }
    return _matchTime;
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"biuID":@"chat_id",
             @"haveSee":@"already_seen",
             @"matchTime":@"time",
             @"referenceId":@"reference_id",
             
             @"userCode":@"user_code",
             @"userName":@"nickname",
             @"userProfile":@"icon_thumbnailUrl",
             @"userConstellation":@"starsign",
             @"userAge":@"age",
             @"isStudent":@"isgraduated",
             
             @"schoolId":@"school",
             @"company":@"company",
             @"profession":@"carrer"
             };
}

@end
