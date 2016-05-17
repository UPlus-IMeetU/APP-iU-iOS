//
//  CellChatMsgImgBrowser.h
//  IMeetU
//
//  Created by zhanghao on 16/4/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMMessage.h"
#import "EaseMessageModel.h"

@protocol CellChatMsgImgBrowserDelegate;

@interface CellChatMsgImgBrowser : UICollectionViewCell

@property (nonatomic, weak) id<CellChatMsgImgBrowserDelegate> delegateCell;

- (void)initWithImage:(UIImage*)image;

- (void)initWithImageMsg:(EMMessage *)imageMsg;

@end
@protocol CellChatMsgImgBrowserDelegate <NSObject>
- (void)cellChatMsgImgBrowser:(CellChatMsgImgBrowser*)cell didClose:(BOOL)close;

@end
