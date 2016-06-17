//
//  ModelRemoteNotificationSendBiu.h
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelRemoteNotificationSendBiu : NSObject

@property (nonatomic, copy) NSString *biuCode;
@property (nonatomic, copy) NSString *referenceId;

@property (nonatomic, copy) NSString *biuUserCode;
@property (nonatomic, copy) NSString *biuUserName;
@property (nonatomic, assign) NSInteger biuUserGender;
@property (nonatomic, assign) NSInteger biuUserAge;
@property (nonatomic, copy) NSString *biuUserConstellation;
@property (nonatomic, assign) NSInteger biuIsGraduated;
@property (nonatomic, copy) NSString *biuUserSchool;
@property (nonatomic, copy) NSString *biuUserCompany;
@property (nonatomic, copy) NSString *biuUserProfession;
@property (nonatomic, copy) NSString *biuUserProfile;
@property (nonatomic, assign) NSInteger biuMatchTime;

@end
