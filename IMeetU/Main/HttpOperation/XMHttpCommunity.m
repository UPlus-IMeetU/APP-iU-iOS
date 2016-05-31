//
//  XMHttpCommunity.m
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpCommunity.h"
#import <YYKit/YYKit.h>

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

- (void)praisePostWithId:(NSInteger)postId withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmDoPraise];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"postId":[NSNumber numberWithInteger:postId]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];
}

- (void)allPostTagWithTime:(long long)time postNum:(long long)postNum callback:(XMHttpCallBackPostTagsAll)callback{
    NSString *url = [XMUrlHttp xmPostTagsAll];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                             @"time":[NSNumber numberWithLongLong:time],
                             @"postNum":[NSNumber numberWithLongLong:postNum]
                             }];
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        callback (code, [ModelTagsAll modelWithJSON:response], error);
    }];
}

- (void)searchPostTagWithStr:(NSString *)str num:(int)num callback:(XMHttpCallBackPostTagsSearch)callback{
    NSString *url = [XMUrlHttp xmPostTagsSearch];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"searchStr":str,
                                                                         @"num":[NSNumber numberWithInt:num]
                                                                         }];

    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        callback (code, [ModelTagsSearch modelWithJSON:response], error);
    }];
}

- (void)createPostTagWithContent:(NSString *)content callback:(XMHttpCallBackPostTagsCreate)callback{
    NSString *url = [XMUrlHttp xmPostTagsCreate];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"content":content
                                                                         }];
    
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            ModelTag *model = [[ModelTag alloc] init];
            model.tagId = [response[@"tagId"] integerValue];
            model.content = content;
            callback (code, model, nil);
        }else{
            callback (code, nil, error);
        }
    }];
}

- (void)releasePostTxtImgWithTags:(NSArray *)tags imgs:(NSArray *)imgs content:(NSString *)content callback:(XMHttpCallBackPostTxtImgCreate)callback{
    NSString *url = [XMUrlHttp xmPostTxtImgRelease];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"type":@1,
                                                                         @"tags":tags,
                                                                         @"imgs":imgs,
                                                                         @"content":content
                                                                         }];
    NSLog(@"=======>%@", [param modelToJSONString]);
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            NSString *postId = response[@"postId"];
            callback (code, postId, nil);
        }else{
            callback (code, nil, error);
        }
    }];
}
@end
