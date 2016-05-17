//
//  ModelActivity.h
//  IMeetU
//
//  Created by Spring on 16/5/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelAdvert.h"
@interface ModelActivity : NSObject
@property (nonatomic,strong) ModelAdvert *dialog;
@property (nonatomic,assign) NSUInteger updateAt;
@property (nonatomic,strong) NSArray *actys;
@property (nonatomic,assign) NSUInteger status;
@end
