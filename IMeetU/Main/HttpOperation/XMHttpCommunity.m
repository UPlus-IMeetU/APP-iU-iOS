//
//  XMHttpCommunity.m
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttpCommunity.h"
#import <YYKit/YYKit.h>
#import "MJRefresh.h"

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

- (void)createReportWithPostId:(NSInteger) postId withCommentId:(NSInteger) commentId withUserCode: (NSInteger) userCode withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmCreateReport];
    NSDictionary *dict ;
    if (postId == -1) {
        dict = @{@"commentId":[NSNumber numberWithInteger:commentId],@"userCode":[NSNumber numberWithInteger:userCode]};
    }else{
        dict = @{@"postId":[NSNumber numberWithInteger:postId],@"userCode":[NSNumber numberWithInteger:userCode]};
    }
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:dict];
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
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            NSString *postId = response[@"postId"];
            callback (code, postId, nil);
        }else{
            callback (code, nil, error);
        }
    }];
    
}

- (void)createCommentWithPostId:(NSInteger)postId withParentId:(NSInteger)parentId withToUserCode:(NSInteger)toUserCode
                    withContent:(NSString *)content callback:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmCreateComment];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"postId":[NSNumber numberWithInteger:postId],
                                                                         @"parentId":[NSNumber numberWithInteger:parentId],
                                                                         @"toUserCode":[NSNumber numberWithInteger:toUserCode],
                                                                         @"content":content}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];

    
}
- (void)deleteCommentWithId:(NSInteger) commentId withCallBack:(XMHttpCallBackNormal)callback{
    NSString *url = [XMUrlHttp xmDeleteComment];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"commentId":[NSNumber numberWithInteger:commentId]}];
    
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            callback(code,response,nil);
        }else{
            callback(code,nil,error);
        }
    }];

}

- (void)grabCommBiuWithUserCode:(NSInteger) userCode withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmGrabCommBiu];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"userCode":[NSNumber numberWithInteger:userCode]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];

}

- (void)communityNitifiesWithTime:(long long)time callback:(XMHttpCallBackCommunityNotifies)callback{
    NSString *url = [XMUrlHttp xmCommunityNitifies];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{
                                                                         @"time":[NSNumber numberWithLongLong:time]
                                                                         }];
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        callback (code, [ModelCommunityNotifies modelWithJSON:response], error);
    }];
}

- (void)getMyPostListWithTime:(long long)time withUserCode:(NSInteger) userCode withCallBack:(XMHttpBlockStandard)callback{
    NSString *url = [XMUrlHttp xmGetMyPostList];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{@"time":[NSNumber numberWithLongLong:time],@"userCode":[NSNumber numberWithInteger:userCode]}];
    [self.httpManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        callback(response.state,response.data,task,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(RESPONSE_CODE_ERR,nil,task,error);
    }];
}

- (void)communityCleanNitifiesWithCallback:(void (^)(NSInteger, NSError *))callback{
    NSString *url = [XMUrlHttp xmCommunityNitifiesClean];
    NSDictionary *param = [self parametersFactoryAppendTokenDeviceCode:@{}];
    [self NormalPOST:url parameters:param callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        callback (code, error);
    }];
}

@end
