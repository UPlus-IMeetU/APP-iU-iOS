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

@end
@implementation ReusableViewBiuReceiveSection

- (void)initWithSection:(NSInteger)section count:(NSInteger)count{
    if (section == 1) {
        [self.titleSection setText:[NSString stringWithFormat:@"[%lu]个命中标签", count]];
    }else if (section == 2){
        [self.titleSection setText:[NSString stringWithFormat:@"[%lu]个兴趣爱好", count]];
    }
}

@end
