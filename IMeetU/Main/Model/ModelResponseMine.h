//
//  ModelResponseMine.h
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelResponseMine : NSObject

@property (nonatomic, copy) NSString *profileCircle;
@property (nonatomic, copy) NSString *profileOrigin;
@property (nonatomic, assign) int profileStatus;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, copy) NSString *aboutMe;
@property (nonatomic, copy) NSString *nameNick;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *homeTown;
@property (nonatomic, assign) NSInteger bodyHeight;
@property (nonatomic, assign) NSInteger bodyWeight;
@property (nonatomic, assign) NSInteger isGraduated;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *company;

@property (nonatomic, strong) NSArray *characters;
@property (nonatomic, strong) NSArray *interests;
@property (nonatomic, strong) NSArray *interested_tags;

@property (nonatomic, assign) NSInteger distanceToTA;
@property (nonatomic, assign) NSInteger matchScore;
@property (nonatomic, assign) long long actyTime;

@property (nonatomic, assign) NSInteger userIdentifier;
@property (nonatomic, assign) NSInteger biuCode;
@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, assign) NSInteger todayNum;

@end
