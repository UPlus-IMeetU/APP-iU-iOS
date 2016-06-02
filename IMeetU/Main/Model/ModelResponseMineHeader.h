//
//  ModelResponseMineHeader.h
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelResponseMineHeader : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) NSDictionary *userinfo;
@end
