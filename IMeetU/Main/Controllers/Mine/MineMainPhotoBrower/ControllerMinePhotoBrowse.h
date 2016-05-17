//
//  ControllerMineMainPhotoBrower.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelMinePhoto;

@protocol ControllerMinePhotoBrowseDelegate;

@interface ControllerMinePhotoBrowse : UIViewController

@property (nonatomic, weak) id<ControllerMinePhotoBrowseDelegate> delegatePhotoBrowse;
+ (instancetype)controllerWithPhotos:(NSMutableArray*)photos startIndex:(NSInteger)index isMine:(BOOL)isMine;

@end
@protocol ControllerMinePhotoBrowseDelegate <NSObject>
@optional
- (void)controllerMinePhotoBrowse:(ControllerMinePhotoBrowse*)controller deletePhotos:(NSArray*)photos;

@end