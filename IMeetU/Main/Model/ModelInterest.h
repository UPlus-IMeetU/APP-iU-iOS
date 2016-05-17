//
//  ModelInterest.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelInterest : NSObject

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *bgName;
@property (nonatomic, copy) NSString *bgNameSelected;

@end
