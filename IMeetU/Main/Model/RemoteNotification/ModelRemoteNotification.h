//
//  ModelRemoteNotification.h
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelRemoteNotification : NSObject

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL shake;

@property (nonatomic, assign) NSString *jsonBody;

@end
