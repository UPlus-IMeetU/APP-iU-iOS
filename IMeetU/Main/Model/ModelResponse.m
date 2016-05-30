//
//  ModelResponse.m
//  IMeetU
//
//  Created by zhanghao on 16/3/13.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelResponse.h"
#import <YYKit/YYKit.h>
#import "UserDefultAccount.h"
#import "EMSDK.h"

@implementation ModelResponse

+ (instancetype)responselWithObject:(id)responseObject{
    ModelResponse *model = [ModelResponse modelWithDictionary:responseObject];
    model.data = responseObject[@"data"];
    return model;
}

- (NSInteger)state{
    if (_state == 303) {
        [UserDefultAccount cleanAccountCache];
        //退出环信
        dispatch_queue_t queue = dispatch_queue_create("em.logout.setting", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            EMError *logoutErr = [[EMClient sharedClient] logout:YES];
            if (logoutErr) {
                
            }
        });
    }
    return _state;
}

@end
