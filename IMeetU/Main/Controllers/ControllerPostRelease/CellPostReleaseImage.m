//
//  CellPostReleaseImage.m
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellPostReleaseImage.h"

@interface CellPostReleaseImage()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhoto;

@end
@implementation CellPostReleaseImage

- (void)initWithPhoto:(UIImage *)photo{
    [self.imgViewPhoto setImage:photo];
}

@end
