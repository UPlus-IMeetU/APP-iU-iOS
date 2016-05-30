//
//  ModelPostDetail.h
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPostDetail : NSObject
@property (nonatomic,copy) NSString *token;
@property (nonatomic,assign) NSInteger postId;
@property (nonatomic,assign) NSInteger userCode;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *
userHead;
@property (nonatomic,copy) NSString *userSchool;
@property (nonatomic,assign) long long creatAt;
@property (nonatomic,strong) NSArray *imgs;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSInteger praiseNum;
@property (nonatomic,assign) NSInteger
commentNum;
@property (nonatomic,assign) BOOL isPraise;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,assign) BOOL hasNext;
@property (nonatomic,strong) NSArray *commentList;
@end
