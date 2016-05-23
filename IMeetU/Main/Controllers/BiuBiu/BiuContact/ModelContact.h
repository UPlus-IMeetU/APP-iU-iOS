//
//  ModelContact.h
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelContact : NSObject

@property (nonatomic, copy) NSString *profileUrl;
@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *nameNick;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger isGraduated;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *schoolId;

@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, strong) NSNumber *ageObj;
@property (nonatomic, strong) NSNumber *genderObj;
@property (nonatomic, strong) NSNumber *isGraduatedObj;

+ (instancetype)modelWithUserCode:(NSString*)userCode;

@end
