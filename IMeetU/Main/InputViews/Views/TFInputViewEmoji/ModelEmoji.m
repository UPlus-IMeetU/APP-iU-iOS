//
//  ModelEmoji.m
//  MeetU
//
//  Created by zhanghao on 15/9/27.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "ModelEmoji.h"

@implementation ModelEmoji

+ (instancetype)modelWithImageKey:(NSString*)imageKey image:(NSString*)image{
    ModelEmoji *model = [[ModelEmoji alloc] initWithImageKey:imageKey image:image];
    
    return model;
}

- (instancetype)initWithImageKey:(NSString*)imageKey image:(NSString*)image{
    if (self = [super init]) {
        _imageKey = imageKey;
        _image = [UIImage imageNamed:image];
        _im = image;
    }
    return self;
}
@end
