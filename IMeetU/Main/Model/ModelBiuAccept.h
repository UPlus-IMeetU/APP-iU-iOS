//
//  ModelBiuAccept.h
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBiuAccept : NSObject

@property (nonatomic, assign) NSInteger userCode;
@property (nonatomic, copy) NSString *nameNick;
@property (nonatomic, copy) NSString *urlProfile;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *schoolID;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger virtualCurrency;
@property (nonatomic, assign) NSInteger timestamp;

@end
