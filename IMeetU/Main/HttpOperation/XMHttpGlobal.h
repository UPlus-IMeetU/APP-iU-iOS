//
//  XMHttpGlobal.h
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttp.h"

@interface XMHttpGlobal : XMHttp

- (void)globalGetAppStatusWithCallback:(XMHttpBlockStandard)callback;

@end
