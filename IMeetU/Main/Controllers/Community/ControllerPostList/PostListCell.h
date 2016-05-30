//
//  PostListCell.h
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PostViewPraiseBlock) (NSInteger postId,NSInteger praise);
typedef void (^PostViewGoSameTagListBlock) (NSInteger tagId);
typedef void (^PostViewOperationBlock) (NSInteger userCode);
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
@end
