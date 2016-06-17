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
    
    faceStar.userCode = model.biuSend.biuUserCode;
    faceStar.userName = model.biuSend.biuUserName;
    faceStar.userAge = model.biuSend.biuUserAge;
    faceStar.haveSee = NO;
    faceStar.userConstellation = model.biuSend.biuUserConstellation;
    faceStar.schoolId = model.biuSend.biuUserSchool;
    faceStar.company = model.biuSend.biuUserCompany;
    faceStar.profession = model.biuSend.biuUserProfession;
    faceStar.userProfile = model.biuSend.biuUserProfile;
    faceStar.matchTime = model.biuSend.biuMatchTime;
    
    return faceStar;
}

+ (instancetype)modelWithModelUserMatch:(ModelUserMatch *)model{
    ModelBiuFaceStar *faceStar = [[ModelBiuFaceStar alloc] init];
    faceStar.userCode = [NSString stringWithFormat:@"%lu", (long)model.userCode];
    faceStar.userName = model.nameNick;
    faceStar.userAge = model.age;
    faceStar.userGender = model.gender;
    faceStar.userProfile = model.urlProfileThumbnail;
    faceStar.userConstellation = model.constellation;
    faceStar.schoolId = [NSString stringWithFormat:@"%lu", (long)model.schoolID];
    faceStar.haveSee = model.isShow;
    faceStar.matchTime = model.timeSendBiu;
    
    return faceStar;
}

- (ModelUserMatch *)getModelUserMatch{
    ModelUserMatch *model = [[ModelUserMatch alloc] init];
    
    model.userCode = [self.userCode integerValue];
    model.nameNick = self.userName;
    model.age = self.userAge;
    model.gender = self.userGender;
    model.urlProfileThumbnail = self.userProfile;
    model.constellation = self.userConstellation;
    model.schoolID = [self.schoolId integerValue];
    model.isShow = self.haveSee;
    model.timeSendBiu = self.matchTime;
    
    return model;
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
