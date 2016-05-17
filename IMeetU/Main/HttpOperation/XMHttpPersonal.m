//
//  XMHttpPersion.m
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpPersonal.h"

@implementation XMHttpPersonal

+ (instancetype)http{
    return [[XMHttpPersonal alloc] init];
}

- (void)xmReportWithUserCode:(NSString*)userCode reason:(NSString*)reason block:(XMHttpBlockStandard)block{
    NSString *url = [XMUrlHttp xmReportUser];
    NSDictionary *para = [self parametersFactoryAppendTokenDeviceCode:@{@"user_code":userCode, @" reason":reason}];
    
    [self.httpManager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        block (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block (RESPONSE_CODE_ERR, nil, task, error);
    }];
}

- (void)xmChangeProfileStateReadWithUserCode:(NSString *)userCode block:(XMHttpBlockStandard)block{
    NSString *url = [XMUrlHttp xmChangeUserStateRead];
    NSDictionary *para = [self parametersFactoryAppendTokenDeviceCode:@{}];
    
    [self.httpManager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        block (response.state, response.data, task, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block (RESPONSE_CODE_ERR, nil, task, error);
    }];
}

@end
