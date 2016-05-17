//
//  ModelMineAlterInterestSection.h
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelMineAlterInterest;

@interface ModelMineAlterInterestSection : NSObject

@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, copy) NSString *sectionCode;
@property (nonatomic, strong) NSArray *interests;

- (NSInteger)numberOfInterests;
- (ModelMineAlterInterest*)modelInterestForCellAtRow:(NSInteger)row;

@end
