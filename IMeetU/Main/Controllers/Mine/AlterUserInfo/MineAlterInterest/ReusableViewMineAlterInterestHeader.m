//
//  CollectionReusableView.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ReusableViewMineAlterInterestHeader.h"

@interface ReusableViewMineAlterInterestHeader()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
@implementation ReusableViewMineAlterInterestHeader

- (void)initWithTitle:(NSString *)title{
    [self.labelTitle setText:title];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
