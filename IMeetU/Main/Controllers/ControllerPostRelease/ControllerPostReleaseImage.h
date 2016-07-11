//
//  ControllerPostReleaseImage.h
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelTag.h"
@protocol ControllerPostReleaseImageDelegate;

@interface ControllerPostReleaseImage : UIViewController

+ (instancetype)controllerWithPhotos:(NSArray*)photos;

@property (nonatomic, weak) id<ControllerPostReleaseImageDelegate> delegatePostImage;
@property (nonatomic, strong) ModelTag *tagModel;
@end
@protocol ControllerPostReleaseImageDelegate <NSObject>
@optional
- (void)controllerPostReleaseImageCancel:(ControllerPostReleaseImage*)controller;
- (void)controllerPostReleaseImageFinish:(ControllerPostReleaseImage*)controller result:(BOOL)result;

@end