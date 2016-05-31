//
//  ModelTagsSearch.h
//  IMeetU
//
//  Created by zhanghao on 16/5/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ModelTag;
@interface ModelTagsSearch : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) int num;
@property (nonatomic, strong) NSArray *postTags;

@property (nonatomic, copy) NSString *searchStr;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (NSString*)tagContentWithIndexPath:(NSIndexPath*)indexPath;

- (ModelTag*)modelWithIndexPath:(NSIndexPath*)indexPath;

- (NSString*)titleWithIndex:(NSInteger)index;
@end
