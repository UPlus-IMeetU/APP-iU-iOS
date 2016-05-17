//
//  CustomMessageCell.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 15/8/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EaseCustomMessageCell.h"
#import "EaseBubbleView+Gif.h"
#import "UIImageView+EMWebCache.h"
#import "UIImage+EMGIF.h"
#import "IMessageModel.h"

#import <BQMM/BQMM.h>
#import "EMBubbleView+MMText.h"
#import "MMTextView.h"

@interface EaseCustomMessageCell ()

@end

@implementation EaseCustomMessageCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
}

#pragma mark - IModelCell

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
#pragma mark - 表情MM修改
    BOOL flag = NO;
    switch (model.bodyType) {
        case EMMessageBodyTypeText:
        {
            if ([model.mmExt objectForKey:@"em_emotion"]) {
                flag = YES;
            }
            else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
                flag = YES;
            }
            else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
                flag = YES;
            }
        }
            break;
        default:
            break;
    }
    return flag;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
#pragma mark - 表情MM修改
    if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
        [_bubbleView.textView setMmTextData:model.mmExt[@"msg_data"]];
    }else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
        //大表情显示
        self.bubbleView.imageView.image = [UIImage imageNamed:@"mm_emoji_loading"];
        NSArray *codes = nil;
        if (model.mmExt[@"msg_data"]) {
            codes = @[model.mmExt[@"msg_data"][0][0]];
        }
        //兼容1.0之前（含）版本的消息格式
        else {
            codes = @[model.text];
        }
        __weak typeof(self) weakSelf = self;
        [[MMEmotionCentre defaultCentre] fetchEmojisByType:MMFetchTypeBig codes:codes completionHandler:^(NSArray *emojis) {
            if (emojis.count > 0) {
                MMEmoji *emoji = emojis[0];
                if ([weakSelf.model.mmExt[@"msg_data"][0][0] isEqualToString:emoji.emojiCode]) {
                    weakSelf.bubbleView.imageView.image = emoji.emojiImage;
                }
            }
            else {
                weakSelf.bubbleView.imageView.image = [UIImage imageNamed:@"mm_emoji_error"];
            }
        }];
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
#pragma mark - 表情MM修改
    if ([model.mmExt objectForKey:@"em_emotion"]) {
        [_bubbleView setupGifBubbleView];
        
        _bubbleView.imageView.image = [UIImage imageNamed:model.failImageName];
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
        [_bubbleView setupMMTextBubbleViewWithModel:model];
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
        [_bubbleView setupGifBubbleView];
        
        _bubbleView.imageView.image = [UIImage imageNamed:model.failImageName];
    }
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
        [_bubbleView updateMMTextMargin:bubbleMargin];
    }else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
        [_bubbleView updateGifMargin:bubbleMargin];
    }
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    if ([model.mmExt objectForKey:@"em_emotion"]) {
        return model.isSender?@"EaseMessageCellSendGif":@"EaseMessageCellRecvGif";
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
        return model.isSender?@"EaseMessageCellSendMMText":@"EaseMessageCellRecvMMText";
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
        return model.isSender?@"EaseMessageCellSendGif":@"EaseMessageCellRecvGif";
    }
    else {
        NSString *identifier = [EaseBaseMessageCell cellIdentifierWithModel:model];
        return identifier;
    }
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    if ([model.mmExt objectForKey:@"em_emotion"]) {
        return 100;
    }
    else if ([model.mmExt[@"txt_msgType"] isEqualToString:@"facetype"]) {
        return kEMMessageImageSizeHeight;
    }
    else {
        CGFloat height = [EaseBaseMessageCell cellHeightWithModel:model];
        return height;
    }
}

@end
