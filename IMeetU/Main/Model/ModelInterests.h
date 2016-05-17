//
//  ModelInterests.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ModelInterest;

@interface ModelInterests : NSObject

+ (instancetype)modelInterestsWithSelected:(NSDictionary*)selected;

@property (nonatomic, assign) NSInteger sum;
@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, strong) NSDictionary *interestsSelected;
@property (nonatomic, strong) NSMutableDictionary *interests;

- (NSInteger)countOfSection:(NSInteger)section;

- (float)heightTableViewOfRow:(NSInteger)row;

- (NSString*)titleOfSection:(NSInteger)section;

- (UIImage*)pointImgOfSection:(NSInteger)section;

- (ModelInterest*)modelOfSectionKey:(NSString*)key index:(NSInteger)index;

- (ModelInterest*)modelOfIndexPath:(NSIndexPath*)indexPath;

+ (NSString*)bgWithKey:(NSString*)key;
+ (NSString*)bgSelectedWithKey:(NSString*)key;
+ (NSString*)pointWithKey:(NSString*)key;

- (NSDictionary*)interestsSelectedModelToDic;

+ (NSArray*)interestsModelWithDic:(NSDictionary*)dic;

+ (NSArray *)sectionNameKeys;

+ (NSDictionary *)sectionNames;

+ (NSDictionary *)originData;
@end
