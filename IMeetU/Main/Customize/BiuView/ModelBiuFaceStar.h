//
//  ModelBiuFaceStar.h
//  IMeetU
//
//  Created by zhanghao on 16/3/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelRemoteNotification;

@interface ModelBiuFaceStar : NSObject

@property (nonatomic, copy) NSString *biuID;
@property (nonatomic, assign) BOOL haveSee;
@property (nonatomic, assign) NSInteger matchTime;
@property (nonatomic, copy) NSString *referenceId;

@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userProfile;
@property (nonatomic, copy) NSString *userConstellation;
@property (nonatomic, assign) NSInteger userAge;
@property (nonatomic, assign) NSInteger isStudent;

@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *profession;

@property (nonatomic, copy) NSString *contentUrlCover;
@property (nonatomic, copy) NSString *contentUrlPage;
@property (nonatomic, copy) NSString *contentTitle;

+ (instancetype)modelWithRemoteNiti:(ModelRemoteNotification*)model;

@end
