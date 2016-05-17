//
//  ModelBiuFaceStar.h
//  IMeetU
//
//  Created by zhanghao on 16/3/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelUserMatch.h"

@class ModelRemoteNotification;

@interface ModelBiuFaceStar : NSObject

@property (nonatomic, assign) BOOL haveSee;
@property (nonatomic, assign) NSInteger matchTime;

@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userProfile;
@property (nonatomic, copy) NSString *userConstellation;
@property (nonatomic, assign) NSInteger userAge;
@property (nonatomic, assign) NSInteger userGender;
@property (nonatomic, assign) NSInteger isStudent;

@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *profession;

+ (instancetype)modelWithRemoteNiti:(ModelRemoteNotification*)model;

+ (instancetype)modelWithModelUserMatch:(ModelUserMatch*)model;

- (ModelUserMatch*)getModelUserMatch;
@end
