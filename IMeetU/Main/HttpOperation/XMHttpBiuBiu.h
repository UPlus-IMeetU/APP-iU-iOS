//
//  XMHttpBiuBiu.h
//  IMeetU
//
//  Created by zhanghao on 16/5/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMHttp.h"

@interface XMHttpBiuBiu : XMHttp

- (void)loadMatchUserWithCount:(NSInteger)count timestamp:(long long)timestamp callback:(XMHttpBlockStandard)callback;

- (void)loadGrabBiuListWithCallback:(XMHttpBlockStandard)callback;

- (void)acceptUserWithCode:(NSInteger)userCode callback:(XMHttpBlockStandard)callback;

- (void)shutdownBiuWithCallback:(XMHttpBlockStandard)callback;
@end
