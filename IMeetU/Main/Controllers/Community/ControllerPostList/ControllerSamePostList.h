//
//  ControllerSamePostList.h
//  IMeetU
//
//  Created by Spring on 16/5/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControllerSamePostList : UIViewController
@property (nonatomic,copy) NSString *titleName;
@property (assign,nonatomic) NSInteger tagId;

//当为个人动态页面的时候,必须传userCode和BOOL为YES
@property (nonatomic,assign) NSInteger userCode;
@property (assign,nonatomic) BOOL isMyPostList;
+ (instancetype)controllerSamePostList;
@end
