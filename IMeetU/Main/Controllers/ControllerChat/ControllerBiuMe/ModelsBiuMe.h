//
//  ModelsBiuMe.h
//  IMeetU
//
//  Created by zhanghao on 16/6/3.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelBiuMe;

@interface ModelsBiuMe : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, assign) long long time;
@property (nonatomic, strong) NSMutableArray *biuList;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (ModelBiuMe*)modelForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)additionalBiuMe:(NSArray*)biuMeList;
@end
