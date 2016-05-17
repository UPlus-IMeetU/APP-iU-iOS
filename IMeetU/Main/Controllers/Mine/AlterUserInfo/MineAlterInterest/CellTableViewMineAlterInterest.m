//
//  CellTableViewMineAlterInterest.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellTableViewMineAlterInterest.h"

@interface CellTableViewMineAlterInterest()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPoint;

@end
@implementation CellTableViewMineAlterInterest

- (void)initWithPointImg:(UIImage *)img{
    [self.imgViewPoint setImage:img];
}

@end
