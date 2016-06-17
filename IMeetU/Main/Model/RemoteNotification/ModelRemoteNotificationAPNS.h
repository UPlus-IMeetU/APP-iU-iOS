//
//  ModelRemoteNotificationAPNS.h
//  IMeetU
//
//  Created by zhanghao on 16/6/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelRemoteNotificationAPNS : NSObject

@property (nonatomic, assign) int badge;
@property (nonatomic, copy) NSString *alert;
@property (nonatomic, copy) NSString *sound;

@end
