//
//  ModelPostDetail.h
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelPost.h"
@interface ModelPostDetail : NSObject
@property (nonatomic,strong) ModelPost *post;
@property (nonatomic,assign) long long time;
@property (nonatomic,assign) BOOL hasNext;
@property (nonatomic,strong) NSArray *commentList;
@end
