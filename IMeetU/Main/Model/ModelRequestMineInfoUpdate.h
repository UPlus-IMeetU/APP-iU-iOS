//
//  ModelRequestMineInfoUpdate.h
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ModelRequestMineInfoUpdateNameNick @"nickname"
#define ModelRequestMineInfoUpdateAboutMe @"description"
#define ModelRequestMineInfoUpdateBirthday @"birth_date"
#define ModelRequestMineInfoUpdateCity @"city,cityf"
#define ModelRequestMineInfoUpdateHometown @"hometown"
#define ModelRequestMineInfoUpdateHeightWeight @"height,weight"
#define ModelRequestMineInfoUpdateIsStudentProfession @"isgraduated,career"
#define ModelRequestMineInfoUpdateSchool @"school"
#define ModelRequestMineInfoUpdateCompany @"company"
#define ModelRequestMineInfoUpdateConstellation @"starsign"

#define ModelRequestMineInfoUpdateCharacter @"personality_tags"
#define ModelRequestMineInfoUpdateInterests @"interested_tags"

#define ModelRequestMineInfoUpdateFinalActyTime @"activity_time"
#define ModelRequestMineInfoUpdateFinalActyTimeForeOrBackGround @"activity_time,app_status"

@interface ModelRequestMineInfoUpdate : NSObject

+ (instancetype)model;

@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *nameNick;
@property (nonatomic, copy) NSString *aboutMe;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cityNum;
@property (nonatomic, copy) NSString *homeTown;
@property (nonatomic, assign) NSInteger bodyHeight;
@property (nonatomic, assign) NSInteger bodyWeight;
@property (nonatomic, assign) NSInteger isGraduated;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *characters;
@property (nonatomic, copy) NSString *interests;
@property (nonatomic, assign) NSInteger ForeOrBackGround;

@property (nonatomic, assign) NSInteger finalActyTime;

@property (nonatomic, copy) NSString *parameters;
@end
