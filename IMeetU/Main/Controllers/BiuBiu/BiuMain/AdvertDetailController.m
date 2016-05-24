//
//  AdvertDetailController.m
//  IMeetU
//
//  Created by Spring on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "AdvertDetailController.h"
#import "UIStoryboard+Plug.h"
#import "ModelAdvert.h"

@interface AdvertDetailController ()<UIWebViewDelegate>

@property (nonatomic, weak) ModelAdvert *model;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIWebView *advertWebView;
@end

@implementation AdvertDetailController

+ (instancetype)shareControllerAdvertWithModel:(ModelAdvert *)model{
    static AdvertDetailController *controller;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"AdvertDetailController"];
    });
    controller.model = model;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.labelTitle setText:self.model.name];
    
    NSURL *url = [NSURL URLWithString:self.model.url];
    [self.advertWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
