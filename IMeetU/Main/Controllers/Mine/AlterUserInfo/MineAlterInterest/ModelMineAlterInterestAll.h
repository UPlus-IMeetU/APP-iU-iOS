//
//  ModelMineAlterInterests.h
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ModelMineAlterInterestSection;
@class ModelMineAlterInterest;

@interface ModelMineAlterInterestAll : NSObject

@property (nonatomic, strong) NSArray *interestAll;
@property (nonatomic, copy) NSString *token;


- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (NSString*)titleOfHeaderInSection:(NSInteger)section;

- (ModelMineAlterInterest*)modelInterestForCellAtIndexPath:(NSIndexPath*)indexPath;

- (float)heightTableViewOfRow:(NSInteger)row;

- (UIImage *)pointImgOfSection:(NSInteger)section;

- (void)onSelectedOfIndexPath:(NSIndexPath*)indexPath;

- (NSArray*)selected;
@end
