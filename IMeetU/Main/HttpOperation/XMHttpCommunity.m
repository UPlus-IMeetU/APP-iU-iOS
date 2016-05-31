//
//  XMHttpCommunity.m
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpCommunity.h"

@implementation XMHttpCommunity

+ (instancetype)http{
    return [[XMHttpCommunity alloc] init];
}

- (void)loadCommunityListWithType:(NSInteger) postListType withTimeStamp:(long long)timeStamp withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmGetCommunityList];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"type":[NSNumber numberWithInteger:postListType],@"time":[NSNumber numberWithLongLong:timeStamp]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse  *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];
}


- (void)loadPostDetailWithPostId:(NSInteger)postId withTimeStamp:(long long)timeStamp withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmGetPostDetail];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"postId":[NSNumber numberWithInteger:postId],@"time":[NSNumber numberWithLongLong:timeStamp]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];
}


- (void)deletePostWithId:(NSInteger) postId withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmDeletePost];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"postId":[NSNumber numberWithInteger:postId]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];
}

- (void)praisePostWithId:(NSInteger) postId withUserCode:(NSInteger)userCode withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmDoPraise];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"postId":[NSNumber numberWithInteger:postId],@"userCode":[NSNumber numberWithInteger:userCode]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];
}

- (void)getPostListWithId:(NSInteger) postId withTimeStamp:(long long)timeStamp withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmGetPostListWithTagId];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"tagId":[NSNumber numberWithInteger:postId],@"time":[NSNumber numberWithLongLong:timeStamp]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];
}

@end
