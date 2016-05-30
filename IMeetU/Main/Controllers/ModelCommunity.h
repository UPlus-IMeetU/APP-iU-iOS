//
//  ModelCommunity.h
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCommunity : NSObject
@property (nonatomic,copy) NSString *token;
@property (nonatomic,strong) NSArray *banner;
@property (nonatomic,assign) long long time;
@property (nonatomic,assign) BOOL hasNext;
@property (nonatomic,strong) NSArray *postList;
@end
