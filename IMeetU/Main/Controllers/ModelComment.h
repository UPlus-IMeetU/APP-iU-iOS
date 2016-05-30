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
@property (nonatomic,assign) NSInteger fromUserCode;
@property (nonatomic,copy) NSString *fromUserName;
@property (nonatomic,copy) NSString *fromUserHead;
@property (nonatomic,assign) NSInteger toUserCode;
@property (nonatomic,copy) NSString *toUserName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) long long createAt;
@end
