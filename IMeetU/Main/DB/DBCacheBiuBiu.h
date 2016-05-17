//
//  DBCacheBiuBiu.h
//  IMeetU
//
//  Created by zhanghao on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBCache.h"

@class ModelUserMatch;

@interface DBCacheBiuBiu : DBCache

/**
 * 清空数据库
 */
- (void)cleanDB;
/**
 * 查询未显示的Biubiu的个数
 */
- (NSInteger)selectCountOfUnShow;
/**
 * 查询一条最新且未显示过的biubiu
 */
- (ModelUserMatch*)selectLatestAndUnShow;
/**
 * 查询一条最旧的biubiu
 */
- (ModelUserMatch *)selectLastBiu;
/**
 * 设置一条biubiu为已显示
 */
- (void)updateHaveBeenShownWithUserCode:(NSInteger)userCode;
/**
 * 设置所有biubiu为未显示
 */
- (void)updateAllSetUnShow;
/**
 * 查询一个biubiu是否存在
 */
- (BOOL)haveBiuWithUserCode:(NSInteger)userCode;
/**
 * 删除一条biubiu
 */
- (void)deleteWithUserCode:(NSInteger)userCode;
/**
 * 插入一个biubiu
 */
- (void)insertWithModelUserMatch:(ModelUserMatch*)model;
/**
 * 插入一组biubiu
 */
- (void)insertWithArrModelUserMatch:(NSArray*)models;

@end
