//
//  XMHttpGlobal.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpGlobal.h"
#import "UserDefultAppGlobalStatus.h"

@implementation XMHttpGlobal

+ (instancetype)http{
    return [[XMHttpGlobal alloc] init];
}

- (void)globalGetAppStatusWithCallback:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmGetAppGlobalStatus];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{}];
    
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
//            [UserDefultAppGlobalStatus setCountOfNoticeCommunity:[response[@"notifyNum"] integerValue]];
//            [UserDefultAppGlobalStatus setCountOfBiuMe:[response[@"comBiuNum"] integerValue]];
            [UserDefultAppGlobalStatus setComBiuCount:[response[@"comBiuCount"] integerValue]];
            [UserDefultAppGlobalStatus setNoticeCount:[response[@"noticeCount"] integerValue]];
            [UIApplication sharedApplication].applicationIconBadgeNumber = [response[@"comBiuCount"] integerValue] + [response[@"noticeCount"] integerValue];
            
        }else{
            
        }
    }];
}

@end
