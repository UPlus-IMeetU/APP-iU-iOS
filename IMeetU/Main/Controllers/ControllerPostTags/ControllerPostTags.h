//
//  ControllerPostTags.h
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ControllerPostTagsType) {
    ControllerPostTagsTypeCheck,
    ControllerPostTagsTypeRelease
};

@interface ControllerPostTags : UIViewController

+ (instancetype)controllerWithType:(ControllerPostTagsType)type;

@end
