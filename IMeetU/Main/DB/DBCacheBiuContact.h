//
//  DBCacheBiuContact.h
//  IMeetU
//
//  Created by zhanghao on 16/3/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBCache.h"

@class ModelContact;
@class ModelContacts;

@interface DBCacheBiuContact : DBCache

+ (instancetype)shareDAO;

- (void)insertWithModel:(ModelContact*)model;

- (void)updateFromNetworkWithIsForced:(BOOL)forcedUpdate block:(void (^)(BOOL, ModelContacts *))block;
/**
 *  更新联系人数据库
 *
 *  @param contact 所有联系人
 */
- (void)updateContactWithArr:(NSArray*)contact;
/**
 *  根据用户code查询用户
 *
 *  @param userCode 用户code
 *
 *  @return 用户模型
 */
- (ModelContact*)selectContactWithUserCode:(NSString*)userCode;
/**
 *  查询所有联系人
 *
 *  @return 所有联系人
 */
- (NSArray*)selectAllContact;
/**
 *  删除指定联系人
 */
- (void)deleteContacterWithUserCode:(NSString*)userCode;

@end
