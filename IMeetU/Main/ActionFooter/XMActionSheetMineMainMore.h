//
//  XMActionSheetMineMainMore.h
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMActionSheet.h"

@protocol XMActionSheetMineMainMoreDelegate;

@interface XMActionSheetMineMainMore : XMActionSheet

@property (nonatomic, weak) id<XMActionSheetMineMainMoreDelegate> delegateActionSheet;

@end
@protocol XMActionSheetMineMainMoreDelegate <NSObject>
@optional
- (void)xmActionSheetMineMainMoreReport:(XMActionSheetMineMainMore*)view;

- (void)xmActionSheetMineMainMoreCancel:(XMActionSheetMineMainMore *)view;
@end