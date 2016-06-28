//
//  MJIUHeader.m
//  IMeetU
//
//  Created by Spring on 16/6/28.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "MJIUHeader.h"
#import "UIColor+Plug.h"
#import "UserDefultAccount.h"
@interface MJIUHeader()
@property (nonatomic,strong) NSMutableArray *loadImages;
@end
@implementation MJIUHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initGit{
    [self setImages:self.loadImages forState:MJRefreshStateRefreshing];
    [self setImages:self.loadImages forState:MJRefreshStateIdle];
    [self setImages:self.loadImages forState:MJRefreshStatePulling];
    self.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.lastUpdatedTimeLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
    self.lastUpdatedTimeLabel.font =  [UIFont systemFontOfSize:12];
}

- (NSMutableArray *)loadImages{
    if (!_loadImages) {
        _loadImages = [NSMutableArray array];
        NSString *gender = @"";
        //男
        if ([[UserDefultAccount gender] isEqualToString:@"2"]) {
            gender = @"girl";
        }else{
            gender = @"boy";
        }
        for (int index = 1; index <= 5 ; index++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d",gender,index]];
            [_loadImages addObject:image];
        }
    }
    return _loadImages;
}

@end
