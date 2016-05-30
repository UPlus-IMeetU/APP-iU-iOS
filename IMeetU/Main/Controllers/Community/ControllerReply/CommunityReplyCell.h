//
//  CommunityReplyCell.h
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPostDetail.h"
typedef NS_ENUM(NSInteger,OperationType) {
    OperationTypeDelete = 0,
    OperationTypeReport = 1
};
typedef void (^ReplyOperationBlock) (NSInteger userCode,OperationType operationType);
@interface CommunityReplyCell : UITableViewCell
@property (nonatomic,copy) ReplyOperationBlock replyOperationBlock;
@property (nonatomic,strong) ModelPostDetail *modelPostDetail;
@end
