//
//  ModelResponseOSSSecurityToke.h
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelResponseOSSSecurityToke : NSObject

@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *secretKeyId;
@property (nonatomic, copy) NSString *securityToken;
@property (nonatomic, strong) NSDate *expiration;

@end
