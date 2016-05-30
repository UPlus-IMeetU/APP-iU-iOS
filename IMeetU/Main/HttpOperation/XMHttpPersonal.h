//
//  XMHttpPersion.h
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttp.h"

@interface XMHttpPersonal : XMHttp

- (void)xmReportWithUserCode:(NSString*)userCode reason:(NSString*)reason block:(XMHttpBlockStandard)block;

- (void)xmChangeProfileStateReadWithUserCode:(NSString*)userCode block:(XMHttpBlockStandard)block;

@end
