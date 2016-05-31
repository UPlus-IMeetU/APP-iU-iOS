//
//  XMOSS.h
//  IMeetU
//
//  Created by zhanghao on 16/3/13.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AliyunOSSiOS/OSSService.h>

@interface XMOSS : NSObject

+ (void)uploadUserProfileWithImg:(UIImage *)profile progress:(void(^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(id(^)(OSSTask *task, NSString *fileName))finish;

+ (void)updateUserProfileWithImg:(UIImage *)profile progress:(void(^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(id(^)(OSSTask *task, NSString *fileName))finish;

+ (void)uploadFileWithImg:(UIImage*)img prefix:(NSString*)prefix progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(id (^)(OSSTask *task, NSString *fileName))finish;

+ (void)uploadFileWithData:(NSData *)data fileName:(NSString*)fileName progress:(void (^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress finish:(id (^)(OSSTask *task, NSString *fileName))finish;

@end
