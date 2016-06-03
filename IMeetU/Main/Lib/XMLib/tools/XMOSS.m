//
//  XMOSS.m
//  IMeetU
//
//  Created by zhanghao on 16/3/13.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMOSS.h"
#import "NSDate+plug.h"
#import "MLToolsID.h"
#import "AFNetworking.h"
#import "UserDefultAccount.h"
#import "XMUrlHttp.h"
#import <YYKit/YYKit.h>
#import "ModelResponse.h"
#import "ModelResponseOSSSecurityToke.h"

@implementation XMOSS

+ (void)uploadUserProfileWithImg:(UIImage *)profile progress:(void(^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(id(^)(OSSTask *task, NSString *fileName))finish{
    
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    NSString *fileName = [NSString stringWithFormat:@"profile/%@.jpeg", [MLToolsID createUserProfileID]];
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"XWp6VLND94vZ8WNJ" secretKey:@"DSi9RRCv4bCmJQZOOlnEqCefW4l1eP"];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    
    OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
    
    put.objectKey = fileName;
    put.bucketName = @"protect-app";
    
    put.uploadingData = UIImageJPEGRepresentation(profile, 1.0);
    
    put.uploadProgress = progress;
    
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        return finish(task, fileName);
    }];
}

+ (void)updateUserProfileWithImg:(UIImage *)profile progress:(void (^)(int64_t, int64_t, int64_t))progress finish:(id (^)(OSSTask *, NSString *))finish{
    NSString *fileName = [NSString stringWithFormat:@"profile/%@.jpeg", [MLToolsID createUserProfileID]];
    
    [self ossClientWithBlock:^(OSSClient *client, BOOL res) {
        if (res) {
            OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
            
            put.objectKey = fileName;
            put.bucketName = @"protect-app";
            
            put.uploadingData = UIImageJPEGRepresentation(profile, 1.0);
            
            put.uploadProgress = progress;
            
            OSSTask * putTask = [client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                return finish(task, fileName);
            }];
        }else{
            OSSTask *task = [OSSTask taskWithError:[NSError errorWithDomain:@"获取客户端失败" code:0 userInfo:nil]];
            finish (task, nil);
        }
    }];
}

+ (void)uploadFileWithImg:(UIImage*)img prefix:(NSString*)prefix progress:(void (^)(int64_t, int64_t, int64_t))progress finish:(id (^)(OSSTask *task, NSString *))finish{
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.jpeg", prefix, [MLToolsID createUserProfileID]];
    
    [self ossClientWithBlock:^(OSSClient *client, BOOL res) {
        if (res) {
            OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
            
            put.objectKey = fileName;
            put.bucketName = @"protect-app";
            
            put.uploadingData = UIImageJPEGRepresentation(img, 1.0);
            
            put.uploadProgress = progress;
            
            OSSTask * putTask = [client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                return finish(task, fileName);
            }];
        }else{
            OSSTask *task = [OSSTask taskWithError:[NSError errorWithDomain:@"获取客户端失败" code:0 userInfo:nil]];
            finish (task, nil);
        }
    }];
}

+ (void)uploadFileWithData:(NSData *)data fileName:(NSString *)fileName progress:(void (^)(int64_t, int64_t, int64_t))progress finish:(id (^)(OSSTask *, NSString *))finish{
    
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"XWp6VLND94vZ8WNJ" secretKey:@"DSi9RRCv4bCmJQZOOlnEqCefW4l1eP"];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
    
    put.objectKey = fileName;
    put.bucketName = @"protect-app";
    
    put.uploadingData = data;
    
    put.uploadProgress = progress;
    
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        return finish(task, fileName);
    }];
    
}

+ (void)ossClientWithBlock:(void(^)(OSSClient *client, BOOL res))block{
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];

    //获取令牌
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmOSSToken] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            ModelResponseOSSSecurityToke *ossToken = [ModelResponseOSSSecurityToke modelWithJSON:response.data];
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:ossToken.accessKeyId secretKeyId:ossToken.secretKeyId securityToken:ossToken.securityToken];
            OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
            block(client, YES);
        }else{
            block(nil, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, NO);
    }];
}

@end
