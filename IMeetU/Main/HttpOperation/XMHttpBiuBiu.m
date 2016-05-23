//
//  XMHttpBiuBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/5/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpBiuBiu.h"

@implementation XMHttpBiuBiu

+ (instancetype)http{
    return [[XMHttpBiuBiu alloc] init];
}

- (void)loadMatchUserWithCount:(NSInteger)count timestamp:(long long)timestamp callback:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmLoadMatchUsers];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"num":[NSNumber numberWithInteger:count],
                                                                         @"last_date":[NSNumber numberWithLongLong:timestamp]
                                                                         }];
    
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        callback (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback (RESPONSE_CODE_ERR, nil, task, error);
    }];
}

- (void)loadGrabBiuListWithCallback:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmLoadGrabBiuList];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:nil];
    
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        callback (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback (RESPONSE_CODE_ERR, nil, task, error);
    }];
}

- (void)acceptUserWithCode:(NSInteger)userCode callback:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmAcceptUserGrabBiu];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"grab_user_code":[NSNumber numberWithInteger:userCode]
                                                                         }];
    
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        callback (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback (RESPONSE_CODE_ERR, nil, task, error);
    }];
}

- (void)shutdownBiuWithCallback:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmShutdownBiu];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:nil];
    
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        callback (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback (RESPONSE_CODE_ERR, nil, task, error);
    }];
}

@end
