//
//  ControllerPostRelease.h
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PostReleaseSuccessBlock) (BOOL success);
@interface ControllerPostRelease : UIViewController
@property (nonatomic,copy) PostReleaseSuccessBlock postReleaseSuccessBlock;
+ (instancetype)controller;
@end
