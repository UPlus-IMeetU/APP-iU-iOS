//
//  ModelCommunityNotice.h
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ModelCommunityNotice : NSObject

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) long userCode;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userProfile;
@property (nonatomic, copy) NSString *userSchool;
@property (nonatomic, assign) long long createAt;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) long long postId;
@property (nonatomic, copy) NSString *postImg;
@property (nonatomic, copy) NSString *postContent;

@property (nonatomic, assign) CGFloat cellHeight;

@end
