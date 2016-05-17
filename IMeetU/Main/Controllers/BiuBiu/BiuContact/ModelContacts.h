//
//  ModelContacts.h
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelContact;

@interface ModelContacts : NSObject

@property (nonatomic, strong) NSArray *contacts;
+ (instancetype)modelWithContacts:(NSArray*)model;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (ModelContact*)contactForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
