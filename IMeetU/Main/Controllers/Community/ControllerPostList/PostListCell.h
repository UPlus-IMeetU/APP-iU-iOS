//
//  PostListCell.h
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPost.h"
#import "ModelTag.h"
#import "EnumHeader.h"
typedef void (^PostViewPraiseBlock) (NSInteger postId,NSInteger userCode,NSInteger praise);
typedef void (^PostViewGoSameTagListBlock) (ModelTag *modelTag);
typedef void (^PostViewOperationBlock) (NSInteger postId,OperationType operationType,NSInteger userCode);
typedef void (^PostViewGoHomePageBlock)(NSInteger userCode);
typedef void (^PostViewCreateCommentBlock)(NSInteger postId);
@interface PostListCell : UITableViewCell
/**
 *  点赞操作
 */
@property (nonatomic,copy) PostViewPraiseBlock postViewPraiseBlock;
/**
 *  进入相同的标签列表
 */
@property (nonatomic,copy) PostViewGoSameTagListBlock postViewGoSameTagListBlock;
/**
 *  进行相关的操作 举报和删除页面
 */
@property (nonatomic,copy) PostViewOperationBlock postViewOperationBlock;
@property (nonatomic,copy) PostViewGoHomePageBlock postViewGoHomePageBlock;
@property (nonatomic,copy) PostViewCreateCommentBlock
    postViewCreateCommentBlock;
@property (nonatomic,strong) ModelPost *modelPost;

@end
