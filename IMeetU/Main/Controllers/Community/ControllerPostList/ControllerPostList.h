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
typedef NS_ENUM(NSInteger,PostListType) {
    PostListTypeRecommend = 0,
    PostListTypeNew = 1,
    PostListTypeBiuBiu = 2
};


@protocol ControllerPostListDelegate <NSObject>
/**
 *  隐藏上方的选择栏
 *
 *  @param isHidden 是否隐藏 YES为隐藏 NO为不隐藏
 */
- (void)hideTitleView:(BOOL)isHidden;
- (void)pushController:(ControllerReply *)controllerReply;
@end

@interface ControllerPostList : UIViewController
//视图轮播，方便进行相关的暂停和轮播操作
@property (nonatomic,strong) ZXCycleScrollView *cycleScrollView;
@property (nonatomic,assign) PostListType postListType;
@property (nonatomic,weak) id <ControllerPostListDelegate> delegate;
@end
