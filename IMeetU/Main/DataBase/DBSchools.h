//
//  DBSchools.h
//  MeetU
//
//  Created by zhanghao on 15/11/1.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBSchools : NSObject

+ (instancetype)shareInstance;

//查询所有学校
- (NSArray*)selectAllSchool;

/**
 *  模糊查询
 *
 *  @param key 根据key值进行模糊匹配
 *
 *  @return 模糊匹配得到的结果
 */
- (NSArray*)selectSchoolWithKey:(NSString*)key;

- (NSString*)schoolNameWithID:(NSInteger)schoolId;

- (NSDictionary*)schoolWithID:(NSInteger)schoolId;

- (NSArray*)departmentsWithSchoolId:(NSInteger)schoolId;
@end
