//
//  ModelRequestRegister.h
//  IMeetU
//
//  Created by zhanghao on 16/3/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ModelRequestRegister : NSObject

@property (nonatomic, copy) NSString *nameNick;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, assign) NSInteger isGraduated;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityNum;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *urlProfile;
@property (nonatomic, copy) NSString *urlProfileOriginal;
@property (nonatomic, assign) int deviceType;

@property (nonatomic, strong) NSDictionary *httpParameters;

@end
