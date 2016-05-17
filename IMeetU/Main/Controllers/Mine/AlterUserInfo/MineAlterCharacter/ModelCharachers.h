//
//  ModelResponseCharachers.h
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelCharacher;

@interface ModelCharachers : NSObject


@property (nonatomic, strong) NSArray *characters;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) NSInteger characterCount;

- (NSInteger)characterCount;

- (ModelCharacher*)characterOfIndex:(NSInteger)index;

- (NSArray*)selected;
@end
