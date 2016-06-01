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
+ (instancetype)controllerSamePostList;
@end
