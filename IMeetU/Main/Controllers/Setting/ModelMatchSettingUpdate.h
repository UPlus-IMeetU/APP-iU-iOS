//
//  ModelMatchSettingUpdate.h
//  IMeetU
//
//  Created by zhanghao on 16/3/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ModelMatchSettingUpdateGender @"sex"
#define ModelMatchSettingUpdateAreaRange @"city"
#define ModelMatchSettingUpdateAgeCeiling @"age_up"
#define ModelMatchSettingUpdateAgeFloor @"age_down"
#define ModelMatchSettingUpdateCharacters @"personalized_tags"
#define ModelMatchSettingUpdateMsg @"message,sound,vibration"

@interface ModelMatchSettingUpdate : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, copy) NSString *parameters;

@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger areaRange;
@property (nonatomic, assign) NSInteger ageCeiling;
@property (nonatomic, assign) NSInteger ageFloor;
@property (nonatomic, copy) NSString *characters;
@property (nonatomic, assign) NSInteger pushNewMsg;
@property (nonatomic, assign) NSInteger pushSound;
@property (nonatomic, assign) NSInteger pushVibration;

+ (instancetype)model;

@end
