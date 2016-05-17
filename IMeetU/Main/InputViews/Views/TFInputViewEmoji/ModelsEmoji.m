//
//  ModelsEmoji.m
//  MeetU
//
//  Created by zhanghao on 15/9/27.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "ModelsEmoji.h"

#import "ModelEmoji.h"
#import "AppDelegate.h"

@interface ModelsEmoji()

@property (nonatomic, strong) NSMutableArray *models;

@end
@implementation ModelsEmoji

+ (instancetype)modelsEmoji{
    ModelsEmoji *modelEmoji = [[ModelsEmoji alloc] init];
    [modelEmoji loadModel];
    
    return modelEmoji;
}

- (void)loadModel{
    self.models = [NSMutableArray array];
    //从AppDelegate类加载全局表情数据
    NSArray *array;// = [AppDelegate getInstance].emojiList;
    NSDictionary *dic;// = [AppDelegate getInstance].emojiDic;
    
    for (NSString *imageKey in array) {
        NSString *image = [dic objectForKey:imageKey];
        if (image) {
            ModelEmoji *modelEmoji = [ModelEmoji modelWithImageKey:imageKey image:image];
            [self.models addObject:modelEmoji];
        }
    }
    
}

- (NSInteger)numberOfItems{
    return self.models.count;
}

- (UIImage*)imageOfIndex:(NSInteger)index{
    if (index < [self numberOfItems]) {
        ModelEmoji *modelEmoji = [self.models objectAtIndex:index];
        return modelEmoji.image;
    }
    return [[UIImage alloc] init];
}

- (NSString *)imageKeyOfIndex:(NSInteger)index{
    if (index < [self numberOfItems]) {
        ModelEmoji *modelEmoji = [self.models objectAtIndex:index];
        return modelEmoji.imageKey;
    }
    return @"";
}

@end
