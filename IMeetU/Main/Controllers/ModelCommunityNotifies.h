//
//  ModelCommunityNotifies.h
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ModelCommunityNotice;

@interface ModelCommunityNotifies : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger hasNext;
@property (nonatomic, strong) NSMutableArray *notifies;

- (ModelCommunityNotice*)modelWithIndexPath:(NSIndexPath*)indexPath;
- (NSInteger)numberOfRowsInSection;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath*)indexPath;

- (long long)lastNoficeCreateAt;

- (void)additionalNoticeWithArr:(NSArray*)notifies;
@end
