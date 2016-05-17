//
//  EMBubbleView+MMText.h
//  ChatDemo-UI3.0
//
//  Created by LiChao Jun on 16/2/4.
//  Copyright © 2016年 LiChao Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseUI.h"

@class MMTextView;

@interface EaseBubbleView (MMText)

@property(nonatomic, retain) MMTextView *textView;

- (void)setupMMTextBubbleViewWithModel:(id<IMessageModel>)model;

- (void)updateMMTextMargin:(UIEdgeInsets)margin;

@end
