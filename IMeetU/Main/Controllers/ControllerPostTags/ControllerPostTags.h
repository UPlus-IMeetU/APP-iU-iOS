//
//  ControllerPostTags.h
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelTag;
@protocol ControllerPostTagsDelegate;

@interface ControllerPostTags : UIViewController

+ (instancetype)controller;

@property (nonatomic, weak) id<ControllerPostTagsDelegate> delegatePostTags;

@end
@protocol ControllerPostTagsDelegate <NSObject>
@optional
- (void)controllerPostTags:(ControllerPostTags*)controller model:(ModelTag*)model;

@end