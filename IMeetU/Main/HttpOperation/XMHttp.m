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
        _httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _httpManager;
}

- (NSDictionary *)parametersFactoryAppendTokenDeviceCode:(NSDictionary *)parameters{
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [p setObject:[UserDefultAccount token] forKey:@"token"];
    [p setObject:[[UIDevice currentDevice].identifierForVendor UUIDString]  forKey:@"device_code"];
    
    return @{@"data":[p modelToJSONString]};
}

@end
