//
//  ModelBiuSendChatTopics.m
//  IMeetU
//
//  Created by zhanghao on 16/3/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuSendChatTopics.h"
#import "ModelBiuSendChatTopic.h"

@implementation ModelBiuSendChatTopics

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tags" : [ModelBiuSendChatTopic class] };
}

- (NSInteger)numberOfItems{
    return self.tags.count;
}

- (ModelBiuSendChatTopic *)modelOfIndex:(NSInteger)index{
    if (index<[self numberOfItems]) {
        return self.tags[index];
    }
    return nil;
}

- (CGSize)contentSizeOfIndex:(NSInteger)index{
    if (index<[self numberOfItems]) {
        ModelBiuSendChatTopic *topic = self.tags[index];
        return topic.topicSize;
    }
    return CGSizeZero;
}

- (void)selectItemOfIndex:(NSInteger)index{
    
    for (int i=0; i<[self numberOfItems]; i++) {
        if (i<[self numberOfItems]) {
            ModelBiuSendChatTopic *topic = self.tags[i];
            topic.selected = NO;
            if (i==index) {
                topic.selected = YES;
            }
        }
    }
}

@end
