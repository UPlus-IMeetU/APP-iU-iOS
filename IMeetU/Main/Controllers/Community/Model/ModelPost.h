//
//  ModelPost.h
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPost : NSObject
@property (nonatomic,assign) NSInteger postId;
@property (nonatomic,assign) NSInteger userCode;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userHead;
@property (nonatomic,copy) NSString *userSchool;
@property (nonatomic,assign) long long createAt;
@property (nonatomic,strong) NSArray *imgs;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSInteger praiseNum;
@property (nonatomic,assign) NSInteger commentNum;
@property (nonatomic,copy) NSString *userSex;
//0 未读,1 已读
@property (nonatomic,assign) BOOL isPraise;
@property (nonatomic,strong) NSArray *tags;

+ (CGFloat) cellHeightWith:(ModelPost *)modelPost;
@end
