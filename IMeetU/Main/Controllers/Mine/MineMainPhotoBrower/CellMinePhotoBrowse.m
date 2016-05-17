//
//  CellMinePhotoBrowse.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMinePhotoBrowse.h"
#import <YYKit/YYKit.h>

@interface CellMinePhotoBrowse()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhoto;

@end
@implementation CellMinePhotoBrowse

- (void)initWithUrl:(NSString *)url{
    [self.imgViewPhoto setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionIgnoreFailedURL completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
}

@end
