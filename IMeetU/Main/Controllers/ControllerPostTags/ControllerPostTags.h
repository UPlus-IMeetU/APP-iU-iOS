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

typedef NS_ENUM(NSInteger, ControllerPostTagsType) {
    ControllerPostTagsTypeSearch,
    ControllerPostTagsTypeSearchCreate
};
@interface ControllerPostTags : UIViewController

+ (instancetype)controllerWithType:(ControllerPostTagsType)type;

@property (nonatomic, weak) id<ControllerPostTagsDelegate> delegatePostTags;

@end
@protocol ControllerPostTagsDelegate <NSObject>
@optional
- (void)controllerPostTags:(ControllerPostTags*)controller model:(ModelTag*)model;

@end