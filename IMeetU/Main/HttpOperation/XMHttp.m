//
//  XMHttp.m
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttp.h"
#import "UserDefultAccount.h"
#import <YYKit/YYKit.h>


@implementation XMHttp

+ (instancetype)http{
    return [[XMHttp alloc] init];
}

- (AFHTTPSessionManager *)httpManager{
    if (!_httpManager) {
        _httpManager = [AFHTTPSessionManager manager];
        _httpManager.requestSerializer.timeoutInterval = 8.0;
        _httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _httpManager;
}

- (NSDictionary *)parametersFactoryAppendTokenDeviceCode:(NSDictionary *)parameters{
    NSMutableDictionary *p;
    if (parameters) {
        p = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }else{
        p = [NSMutableDictionary dictionary];
    }
    [p setObject:[UserDefultAccount token] forKey:@"token"];
    [p setObject:[[UIDevice currentDevice].identifierForVendor UUIDString]  forKey:@"device_code"];
    
    return @{@"data":[p modelToJSONString]};
}

- (void)NormalPOST:(NSString *)URLString parameters:(id)parameters callback:(XMHttpBlockStandard)callback{
    [self.httpManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (callback) {
            callback (response.state, response.data, task, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback (RESPONSE_CODE_ERR, nil, task, error);
    }];
}
@end
