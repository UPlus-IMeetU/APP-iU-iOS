//
//  ModelBiuSendChatTopic.m
//  IMeetU
//
//  Created by zhanghao on 16/3/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelBiuSendChatTopic.h"

@implementation ModelBiuSendChatTopic

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"topicCode":@"code",
             @"topicContent":@"name"
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"topicCode", @"topicContent"];
}

- (CGSize)topicSize{
    if (!self.isMeasureSize) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        [label setText:self.topicContent];
        self.isMeasureSize = YES;
        _topicSize = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        _topicSize = CGSizeMake(_topicSize.width+16, _topicSize.height+10);
    }
    return _topicSize;
}

@end
