//
//  ModelResponse.h
//  IMeetU
//
//  Created by zhanghao on 16/3/13.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelResponse : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) id data;

+ (instancetype)responselWithObject:(id)responseJson;

@end
