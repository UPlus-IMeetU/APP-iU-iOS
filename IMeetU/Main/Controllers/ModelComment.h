//
//  ModelComment.h
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  评论类
 */
@interface ModelComment : NSObject
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,assign) NSInteger userFromCode;
@property (nonatomic,copy) NSString *userFromName;
@property (nonatomic,copy) NSString *userFromHead;
@property (nonatomic,copy) NSString *userFromSchool;
@property (nonatomic,assign) NSInteger userToCode;
@property (nonatomic,copy) NSString *userToName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) long long createAt;
@property (nonatomic,copy) NSString *userToSex;
@property (nonatomic,copy) NSString *userFromSex;
@end
