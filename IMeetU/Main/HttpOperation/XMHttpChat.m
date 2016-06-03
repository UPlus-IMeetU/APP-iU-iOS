//
//  XMHttpChat.m
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpChat.h"
#import <YYKit/YYKit.h>

@implementation XMHttpChat

+ (instancetype)http{
    return [[XMHttpChat alloc] init];
}

- (void)xmUnfriendYouWithUserCode:(NSString*)userCode block:(XMHttpBlockStandard)block{
    if (!userCode || userCode.length<1) {
        if (block) {
            block (RESPONSE_CODE_ERR, nil, nil, nil);
        }
        return;
    }
    
    NSString *url = [XMUrlHttp xmUnfriendYou];
    NSDictionary *para = [self parametersFactoryAppendTokenDeviceCode:@{@"user_code":userCode}];
    
    [self.httpManager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        block (response.state, response.data, task, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block (-1, nil, task, error);
    }];
}

- (void)getBiuMeListWithTime:(long long)time callback:(void (^)(NSInteger, ModelsBiuMe *, NSError *))callback{
    NSString *url = [XMUrlHttp xmBiuMeListGet];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"time":[NSNumber numberWithLongLong:time]
                                                                         }];
    
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        callback (code, [ModelsBiuMe modelWithJSON:response], error);
    }];
}

- (void)acceptBiuMeWithCode:(NSInteger)usercode callback:(void (^)(NSInteger, NSString *, NSError *))callback{
    NSString *url = [XMUrlHttp xmBiuMeListAccept];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"userCode":[NSNumber numberWithInteger:usercode]
                                                                             }];
    
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        callback (code, response[@"token"], error);
    }];
}

- (void)cleanBiuMeWithCallback:(void (^)(NSInteger, NSString *, NSError *))callback{
    NSString *url = [XMUrlHttp xmBiuMeListClean];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{}];
    
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        callback (code, response[@"token"], error);
    }];
}
@end
