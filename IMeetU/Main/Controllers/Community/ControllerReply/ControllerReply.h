//
//  ControllerReply.h
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControllerReply : UIViewController
/**
 *  帖子的ID
 */
@property (nonatomic,assign) NSUInteger postId;
/**
 *  不准跳转到详情页
 */
@property (nonatomic,assign) BOOL notGoSameList;
/**
 *  输入框
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/**
 *  单例方法
 *
 *  @return 返回页面的单例对象
 */
+ (instancetype)shareControllerReply;

@end
