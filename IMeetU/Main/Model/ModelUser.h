//
//  ModelUser.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUser : NSObject

@property (nonatomic, copy) NSString *nameNick;

@property (nonatomic, copy) NSString *profileThumbUrl;
@property (nonatomic, copy) NSString *profileOrignUrl;

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) NSInteger matchingDegree;
@property (nonatomic, assign) NSDate *matchingDate;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, copy) NSString *personalIntroductions;

@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *homeTown;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, assign) NSInteger isStudent;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *company;

@property (nonatomic, strong) NSMutableArray *character;
@property (nonatomic, strong) NSDictionary *interest;

+ (NSArray*)allCharater;
@end
