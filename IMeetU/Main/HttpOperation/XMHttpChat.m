//
//  XMHttpChat.m
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpChat.h"

@implementation XMHttpChat

+ (instancetype)http{
    return [[XMHttpChat alloc] init];
}

- (void)xmUnfriendYouWithUserCode:(NSString*)userCode block:(XMHttpBlockStandard)block{
    NSString *url = [XMUrlHttp xmUnfriendYou];
    NSDictionary *para = [self parametersFactoryAppendTokenDeviceCode:@{@"user_code":userCode}];
    
    [self.httpManager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        block (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block (-1, nil, task, error);
    }];
}

@end
