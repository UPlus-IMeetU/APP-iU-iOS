//
//  ModelTagsAll.h
//  IMeetU
//
//  Created by zhanghao on 16/5/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelTag.h"

@interface ModelTagsAll : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, assign) long long time;
@property (nonatomic, assign) long long postNum;

@property (nonatomic, strong) NSArray *postRecommend;
@property (nonatomic, strong) NSArray *postHot;
@property (nonatomic, strong) NSArray *postNewest;

- (void)additionalNewerWithTags:(NSArray*)tags;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (NSString*)tagContentWithIndexPath:(NSIndexPath*)indexPath;

- (ModelTag*)modelWithIndexPath:(NSIndexPath*)indexPath;

- (NSString*)titleWithIndex:(NSInteger)index;
@end
