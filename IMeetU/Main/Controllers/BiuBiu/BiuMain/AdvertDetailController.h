//
//  AdvertDetailController.h
//  IMeetU
//
//  Created by Spring on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelAdvert;

@interface AdvertDetailController : UIViewController

+ (instancetype)shareControllerAdvertWithModel:(ModelAdvert*)model;

@end
