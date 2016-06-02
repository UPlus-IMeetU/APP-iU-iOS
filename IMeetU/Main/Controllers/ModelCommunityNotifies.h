//
//  ModelCommunityNotifies.h
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCommunityNotifies : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger hasNext;
@property (nonatomic, strong) NSMutableArray *notifies;

@end
