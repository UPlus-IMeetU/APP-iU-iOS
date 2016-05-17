//
//  ModelsEmoji.h
//  MeetU
//
//  Created by zhanghao on 15/9/27.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelsEmoji : NSObject

+ (instancetype)modelsEmoji;

- (NSInteger)numberOfItems;

- (UIImage*)imageOfIndex:(NSInteger)index;

- (NSString*)imageKeyOfIndex:(NSInteger)index;

@end
