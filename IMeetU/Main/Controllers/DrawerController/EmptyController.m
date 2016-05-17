//
//  EmptyController.m
//  IMeetU
//
//  Created by Spring on 16/5/13.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "EmptyController.h"
#import "ControllerChatMsg.h"
@interface EmptyController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation EmptyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHidesBottomBarWhenPushed:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundImageView setImage:self.backgroundImage];
    [self.view addSubview:self.backgroundImageView];
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _backgroundImageView;
}

@end
