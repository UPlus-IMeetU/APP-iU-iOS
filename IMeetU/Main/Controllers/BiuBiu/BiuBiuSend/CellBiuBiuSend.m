//
//  CellBiuBiuSend.m
//  IMeetU
//
//  Created by zhanghao on 16/3/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellBiuBiuSend.h"
#import "UIColor+Plug.h"

@interface CellBiuBiuSend()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBG;
@property (weak, nonatomic) IBOutlet UILabel *labelTopic;

@end
@implementation CellBiuBiuSend

- (void)setTopicContent:(NSString *)content{
    [self.labelTopic setText:content];
}

- (void)initWithModel:(ModelBiuSendChatTopic *)model{
    [self.labelTopic setText:model.topicContent];
    if (model.isSelected) {
        self.labelTopic.textColor = [UIColor whiteColor];
        [self.imgViewBG setImage:[UIImage imageNamed:@"biu_send_cell_chat_topic_light"]];
    }else{
        self.labelTopic.textColor = [UIColor often_6CD1C9:1];
        [self.imgViewBG setImage:[UIImage imageNamed:@"biu_send_cell_chat_topic"]];
    }
}

@end
