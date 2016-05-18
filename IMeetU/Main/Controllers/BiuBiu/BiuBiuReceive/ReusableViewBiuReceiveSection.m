//
//  ReusableViewBiuReceiveSection.m
//  IMeetU
//
//  Created by zhanghao on 16/3/15.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ReusableViewBiuReceiveSection.h"

@interface ReusableViewBiuReceiveSection()
@property (weak, nonatomic) IBOutlet UILabel *titleSection;
@property (weak, nonatomic) IBOutlet UIView *pointView;

@end
@implementation ReusableViewBiuReceiveSection

- (void)awakeFromNib{
    _pointView.layer.cornerRadius = _pointView.frame.size.height * 0.5;
    _pointView.clipsToBounds = YES;
    
}
- (void)initWithSection:(NSInteger)section count:(NSInteger)count{
    if (section == 1) {
        [self.titleSection setText:[NSString stringWithFormat:@"%lu个命中标签", count]];
    }else if (section == 2){
        [self.titleSection setText:[NSString stringWithFormat:@"%lu个兴趣爱好", count]];
    }
}

@end
