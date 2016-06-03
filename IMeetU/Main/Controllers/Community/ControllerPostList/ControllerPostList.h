//
//  ControllerPostList.h
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCycleScrollView.h"
#import "ControllerReply.h"
#import "EnumHeader.h"

@protocol ControllerPostListDelegate <NSObject>
/**
 *  隐藏上方的选择栏
 *
 *  @param isHidden 是否隐藏 YES为隐藏 NO为不隐藏
 */
- (void)hideTitleView:(BOOL)isHidden;
@end

@interface ControllerPostList : UIViewController
//视图轮播，方便进行相关的暂停和轮播操作
@property (nonatomic,strong) ZXCycleScrollView *cycleScrollView;
@property (nonatomic,assign) PostListType postListType;
@property (nonatomic,weak) id <ControllerPostListDelegate> delegate;

//登陆过后，让列表刷新
- (void)refreshView;
- (void)updateView;
@end
