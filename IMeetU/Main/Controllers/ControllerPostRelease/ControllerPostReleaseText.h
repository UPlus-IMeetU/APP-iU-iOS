//
//  ControllerPostReleaseText.h
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelTag.h"
@protocol ControllerPostReleaseTextDelegate;

@interface ControllerPostReleaseText : UIViewController

+ (instancetype)controller;
@property (nonatomic, weak) id<ControllerPostReleaseTextDelegate> delegatePostText;
@property (nonatomic, strong) ModelTag *tagModel;
@end
@protocol ControllerPostReleaseTextDelegate <NSObject>
@optional
- (void)controllerPostReleaseTextCancel:(ControllerPostReleaseText*)controller;

- (void)controllerPostReleaseTextFinish:(ControllerPostReleaseText*)controller result:(BOOL)result;
@end