//
//  XMHttpTools.m
//  IMeetU
//
//  Created by zhanghao on 16/4/23.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpTools.h"

@implementation XMHttpTools

+ (instancetype)http{
    return [[XMHttpTools alloc] init];
}

- (void)getEnablePayWithBlock:(XMHttpBlockStandard)block{
    NSString *url = [XMUrlHttp xmEnablePay];
    NSDictionary *para = [self parametersFactoryAppendTokenDeviceCode:@{@"version":@"1.0.2"}];
    
    [self.httpManager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        block (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block (RESPONSE_CODE_ERR, nil, task, error);
    }];
}

@end
