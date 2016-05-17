//
//  ModelMatchSetting.h
//  IMeetU
//
//  Created by zhanghao on 16/3/10.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ModelMatchSettingGender @"sex,personalized_tags"
#define ModelMatchSettingAreaRange @"city"
#define ModelMatchSettingAgeCeiling @"age_up"
#define ModelMatchSettingAgeFloor @"age_down"
#define ModelMatchSettingCharacters @"personalized_tags"
#define ModelMatchSettingMsg @"message,sound,vibration"

@interface ModelMatchSetting : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, copy) NSString *parameters;

@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger areaRange;
@property (nonatomic, assign) NSInteger ageCeiling;
@property (nonatomic, assign) NSInteger ageFloor;
@property (nonatomic, strong) NSArray *characters;
@property (nonatomic, assign) BOOL pushNewMsg;
@property (nonatomic, assign) BOOL pushSound;
@property (nonatomic, assign) BOOL pushVibration;

@property (nonatomic, assign) NSInteger userGender;
@property (nonatomic, assign) NSInteger userCharcterCount;

+ (instancetype)model;

@end
