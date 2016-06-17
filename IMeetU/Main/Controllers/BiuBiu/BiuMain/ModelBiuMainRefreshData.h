//
//  ModelBiuMainRefreshData.h
//  IMeetU
//
//  Created by zhanghao on 16/3/22.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBiuFaceStar.h"

@interface ModelBiuMainRefreshData : NSObject

@property (nonatomic, assign) NSInteger virtualCurrency;
@property (nonatomic, assign) int profileState;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong) NSArray *faceStars;

@property (nonatomic, strong) ModelBiuFaceStar *matchUser;

@property (nonatomic, copy) NSString *isBiuEnd;

@end
