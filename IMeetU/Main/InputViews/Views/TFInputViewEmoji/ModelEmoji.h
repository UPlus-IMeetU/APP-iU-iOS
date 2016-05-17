//
//  ModelEmoji.h
//  MeetU
//
//  Created by zhanghao on 15/9/27.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelEmoji : NSObject

@property (nonatomic, copy, readonly) NSString *imageKey;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, copy) NSString *im;

+ (instancetype)modelWithImageKey:(NSString*)imageKey image:(NSString*)image;

@end
