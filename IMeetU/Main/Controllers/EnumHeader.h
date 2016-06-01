//
//  EnumHeader.h
//  IMeetU
//
//  Created by Spring on 16/5/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,OperationReplyType) {
    OperationReplyTypeDelete = 0,
    OperationReplyTypeReport = 1
};


typedef NS_ENUM(NSInteger,PostListType) {
    PostListTypeRecommend = 0,
    PostListTypeNew = 1,
    PostListTypeBiuBiu = 2
};

typedef NS_ENUM(NSInteger,OperationType) {
    OperationTypeDelete = 0,
    OperationTypeReport = 1
};

typedef NS_ENUM(NSInteger,RefreshType) {
    Refresh = 0,
    Loading = 1
};