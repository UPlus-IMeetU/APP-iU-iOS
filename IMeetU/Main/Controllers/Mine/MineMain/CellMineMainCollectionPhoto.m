//
//  CellMineMainCollectionPhoto.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMineMainCollectionPhoto.h"
#import <YYKit/YYKit.h>
#import "ModelMinePhoto.h"

@interface CellMineMainCollectionPhoto()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhoto;

@end
@implementation CellMineMainCollectionPhoto

- (void)initWithPhoto:(ModelMinePhoto *)photo{
    [self.imgViewPhoto setImageWithURL:[NSURL URLWithString:photo.photoUrlThumbnail] placeholder:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
