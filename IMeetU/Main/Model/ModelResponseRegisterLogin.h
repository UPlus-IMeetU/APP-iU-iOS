//
//  ModelResponseRegisterLogin.h
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelResponseRegisterLogin : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *imName;
@property (nonatomic, copy) NSString *imPasswork;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *userProfileUrl;
@property (nonatomic, copy) NSString *sex;

@end
