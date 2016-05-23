//
//  DBCache.h
//  MeetU
//
//  Created by zhanghao on 15/10/15.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BIU_BIU @"BiuBiu"
#define BIU_CONTACT @"BiuContactNew"

@class FMDatabase;

@interface DBCache : NSObject

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, copy) NSString *tableName;
/**
 *  获取单例工厂对象
 *
 *  @return 单例工厂对象
 */
+ (instancetype)shareInstance;

@end
