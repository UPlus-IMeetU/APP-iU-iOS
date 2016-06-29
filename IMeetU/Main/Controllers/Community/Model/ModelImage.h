//
//  ModelImage.h
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelImage : NSObject
@property (nonatomic,assign) NSInteger imageWidth;
@property (nonatomic,assign) NSInteger imageHeight;
@property (nonatomic,copy) NSString *imageUrl;
@end
