//
//  ModelBiuReceive.h
//  IMeetU
//
//  Created by zhanghao on 16/3/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelCharacher;
@class ModelMineAlterInterest;

@interface ModelBiuReceive : NSObject

@property (nonatomic, copy) NSString *token;

//biu币总量、每次抢biu消耗量
@property (nonatomic, assign) NSInteger biuAllCount;
@property (nonatomic, assign) NSInteger biuUsedCountOnce;

@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *nameNick;
@property (nonatomic, copy) NSString *userProfile;
@property (nonatomic, copy) NSString *userProfileOrigin;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, assign) NSInteger isGraduated;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *profression;

@property (nonatomic, assign) long long timebefore;
@property (nonatomic, copy) NSString *chatTopic;
@property (nonatomic, strong) NSArray *characters;
@property (nonatomic, strong) NSArray *interests;
@property (nonnull, strong) NSArray *interested_tags;

@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger matchingScore;
@property (nonatomic, assign) NSInteger message;
/**
 *  标记此biu是否已被抢
 */
@property (nonatomic, assign) BOOL isGrabbbed;
/**
 *  标记用户的身份
 */
@property (nonatomic, assign) NSInteger userIdentifier;

@property (nonatomic, assign) NSInteger profileState;


- (ModelCharacher*)modelCharaterOfIndex:(NSInteger)index;

- (ModelMineAlterInterest*)modelInterestOfIndex:(NSInteger)index;

@end
