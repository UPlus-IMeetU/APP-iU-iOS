//
//  XMHttpChat.h
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttp.h"

@interface XMHttpChat : XMHttp

/**
 *  解除关系
 *
 *  @param parameters 请求参数
 *  @param block      回调
 */
- (void)xmUnfriendYouWithUserCode:(NSString*)userCode block:(XMHttpBlockStandard)block;

@end
