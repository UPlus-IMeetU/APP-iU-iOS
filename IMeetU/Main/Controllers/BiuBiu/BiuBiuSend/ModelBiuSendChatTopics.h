//
//  ModelBiuSendChatTopics.h
//  IMeetU
//
//  Created by zhanghao on 16/3/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ModelBiuSendChatTopic;

@interface ModelBiuSendChatTopics : NSObject

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *token;

- (NSInteger)numberOfItems;

- (ModelBiuSendChatTopic*)modelOfIndex:(NSInteger)index;

- (CGSize)contentSizeOfIndex:(NSInteger)index;

- (void)selectItemOfIndex:(NSInteger)index;
@end
