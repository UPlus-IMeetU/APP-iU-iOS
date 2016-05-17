//
//  TFInputViewEmoji.h
//  MeetU
//
//  Created by zhanghao on 15/9/27.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PANEL_W ([UIScreen mainScreen].bounds.size.width)
#define PANEL_H (216)

#define CELL_NUMBER_VERTICAL (3)

#define CELL_W 36
#define CELL_H 36

@protocol XMInputViewEmojiDelegate;

@interface XMInputViewEmoji : UIView

@property (nonatomic, weak) id<XMInputViewEmojiDelegate> delegateXmInputView;
@property (nonatomic, assign, readonly) NSInteger numberOfHorizontal;

+ (instancetype)xmInputViewEmoji;

- (void)scrollZero;
@end
@protocol XMInputViewEmojiDelegate <NSObject>
@optional
- (void)xmInputViewAddEmoji:(NSString*)emoji;

- (void)xmInputViewDelete;

@end