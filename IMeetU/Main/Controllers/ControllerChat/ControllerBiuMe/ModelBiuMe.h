//
//  ModelBiuMe.h
//  IMeetU
//
//  Created by zhanghao on 16/6/3.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBiuMe : NSObject

@property (nonatomic, assign) NSInteger userCode;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userProfile;
@property (nonatomic, copy) NSString *schoolCode;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, assign) long long createdAt;
@property (nonatomic, assign) int gender;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) BOOL isAccept;

@end
