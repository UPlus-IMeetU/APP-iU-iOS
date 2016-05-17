//
//  ModelMineAlterInterest.h
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ModelMineAlterInterest : NSObject

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *interestContent;
@property (nonatomic, copy) NSString *interestCode;

@property (nonatomic, copy) NSString *sectionTitle;

- (UIImage*)bgNameSelected;

- (UIImage*)bgName;
@end
