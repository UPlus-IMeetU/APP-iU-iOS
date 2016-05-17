//
//  ModelBiuSendChatTopic.h
//  IMeetU
//
//  Created by zhanghao on 16/3/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBiuSendChatTopic : NSObject

@property (nonatomic, copy) NSString *topicCode;
@property (nonatomic, copy) NSString *topicContent;
@property (nonatomic, assign) BOOL isMeasureSize;
@property (nonatomic, assign) CGSize topicSize;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
