//
//  CommunityReplyCell.h
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelComment.h"
#import "EnumHeader.h"
typedef void (^ReplyOperationBlock) (NSInteger userCode,OperationReplyType operationType);
@interface CommunityReplyCell : UITableViewCell
@property (nonatomic,copy) ReplyOperationBlock replyOperationBlock;
@property (nonatomic,strong) ModelComment *modelComment;
@end
