//
//  ModelBiuAccepts.h
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBiuAccepts : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger message;

@property (nonatomic, strong) NSArray *users;

@end
