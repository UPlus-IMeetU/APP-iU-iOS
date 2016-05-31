//
//  XMHttp.h
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "ModelResponse.h"

#define RESPONSE_CODE_ERR (-1)

typedef void(^XMHttpBlockStandard)(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error);

@interface XMHttp : NSObject

+ (instancetype)http;

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

- (NSDictionary*)parametersFactoryAppendTokenDeviceCode:(NSDictionary*)parameters;

- (void)NormalPOST:(NSString *)URLString
                    parameters:(id)parameters
                    callback:(XMHttpBlockStandard)callback;

@end
